//
//  File.swift
//
//
//  Created by Chris Davis on 08/10/2022.
//

import Foundation
import OSLog

class Calculate {
  
  private let logger = Logger(subsystem: subsystem, category: "Calculate")
  
  func run(with configuration: Configuration) async throws -> Analytics {
    
    let url: URL
    if let overrideURL = configuration.jsonURL {
      logger.log("Using JSON override URL: \(overrideURL)")
      url = overrideURL
    } else {
      logger.log("Calling API to fetch JSON")
      url = URL(string: "https://raw.githubusercontent.com/nthState/ProductAnalytics/main/Tests/ProductAnalyticsCoreTests/Resources/ExampleProductKeys.json")!
    }
    
    return try await fetchAnalytics(url: url)
  }
  
}

extension Calculate {
  
  public func fetchAnalytics(url: URL) async throws -> Analytics {

    
    let result: Analytics
    do {
      let (data, _) = try await URLSession.shared.data(from: url)
      result = try JSONDecoder().decode(Analytics.self, from: data)
    } catch let error {
      logger.log("fetch Analytics error: \(error.localizedDescription, privacy: .public)")
      throw error
    }
    
    return result
  }
}
