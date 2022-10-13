//
//  Copyright © 2022 Chris Davis, https://www.nthState.com
//
//  See LICENSE for license information.
//

import Foundation
import OSLog

public let subsystem = "com.productAnalysis"

public class Service {
  
  private let logger = Logger(subsystem: subsystem, category: "Service")
  
  public init() {
    
  }
  
  public func run(with configuration: Configuration) async throws -> Int {
    logger.log("Running with configuration: \(configuration, privacy: .public)")
    
    let calculate = DataFetcher() //Should be named something to do with fetching
    let analytics = try await calculate.fetch(with: configuration)
    
    if configuration.generateSourceCode {
      let generate = SourceGenerator()
      try await generate.write(analytics: analytics, with: configuration)
    }
    
    if configuration.enableAnalysis {
      
      let analyse = Analysis()
      var errorCode: Int = 0
      let analysisResults = try await analyse.analyze(analytics: analytics, with: configuration, errorCode: &errorCode)
      
      if errorCode == 1 {
        return 1
      }
      
      if configuration.reportAnalysisResults {
        
        let analysisReporter = AnalysisReporter()
        
        try await analysisReporter.report(results: analysisResults, with: configuration)
      }
    }
    
    return 0
  }
  
}
