//
//  Copyright © 2022 Chris Davis, https://www.nthState.com
//
//  See LICENSE for license information.
//

import Foundation
import OSLog

public let subsystem = "com.productanalytics"

public class Service {
  
  private let logger = Logger(subsystem: subsystem, category: "Service")
  
  public init() {
    
  }
  
  public func run(with configuration: Configuration) async throws {
    logger.log("Running with configuration: \(configuration, privacy: .public)")
    
    let calculate = Calculate() //Should be named something to do with fetching
    let analytics = try await calculate.run(with: configuration)
    
    if configuration.generateSourceCode {
      let generate = Generate()
      try await generate.run(analytics: analytics, with: configuration)
    }
    
    if configuration.enableAnalysis {
      
      let analyse = Analyse()
      let analysisResults = try await analyse.run(analytics: analytics, with: configuration)
      
      if configuration.reportAnalysisResults {
        
        let analysisReporter = AnalysisReporter()
        
        try await analysisReporter.reportAnalysis(results: analysisResults, with: configuration)
      }
    }
    
  }
  
}
