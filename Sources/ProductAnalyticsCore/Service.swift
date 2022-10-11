//
//  File.swift
//  
//
//  Created by Chris Davis on 08/10/2022.
//

import Foundation
import OSLog

enum ProductAnalyticsError: Error {
  case invalidURL
}

public let subsystem = "com.productanalytics"

public class Service {
  
  private let logger = Logger(subsystem: subsystem, category: "Service")
  
  public init() {
    
  }

  public func run(with configuration: Configuration) async throws {
    logger.log("Running with configuration: \(configuration, privacy: .public)")
    
    let calculate = Calculate()
    let analytics = try await calculate.run(with: configuration)
    
    if configuration.generateSourceCode {
      let generate = Generate()
      try await generate.run(analytics: analytics, with: configuration)
    }
    
    if configuration.enableAnalysis {
      
      let analyse = Analyse()
      let analysisResults = await analyse.run(url: URL(string: "not set yet, maybe project dir")!, analytics: analytics, with: configuration)
      
      if configuration.reportAnalysisResults {
        
        let analysisReporter = AnalysisReporter()
        
        try await analysisReporter.reportAnalysis(results: analysisResults, with: configuration)
      }
    }
    
  }

}
