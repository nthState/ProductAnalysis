//
//  File.swift
//  
//
//  Created by Chris Davis on 08/10/2022.
//

import Foundation
import OSLog

class Generate {
  
  let logger = Logger(subsystem: subsystem, category: "Generate")
  
  func run(with configuration: Configuration) async {
    
  }
  
  // TODO: - The output from this can be piped into the Analyse step
  func generate(events: [Any], with configuration: Configuration) -> Any? {
    
    logger.log("In Generate")
    
    return nil
  }
  
}

extension Generate {
  
  public func fetchAnalytics() async throws -> Analytics {
    
    guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1") else {
      throw ProductAnalyticsError.invalidURL
    }
    
    let (data, _) = try await URLSession.shared.data(from: url)
    let result = try JSONDecoder().decode(Analytics.self, from: data)
    return result
  }
}
