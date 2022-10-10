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
    await calculate.run(with: configuration)
    
    if configuration.generateSourceCode {
      let generate = Generate()
      await generate.run(with: configuration)
    }
    
    if configuration.enableAnalysis {
      
      let analyse = Analyse()
      await analyse.run(with: configuration)
      
      if configuration.reportAnalysisResults {
        try await analyse.reportAnalysis()
      }
    }
    
  }

}

public class Analytics: Codable {
  let a: String
}
