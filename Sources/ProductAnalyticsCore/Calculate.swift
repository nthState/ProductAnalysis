//
//  File.swift
//
//
//  Created by Chris Davis on 08/10/2022.
//

import Foundation
import OSLog

class Calculate {
  
  let logger = Logger(subsystem: subsystem, category: "Calculate")
  
  func run(with configuration: Configuration) async {
    
  }
  
  func calculate() -> Any?  {
    
    return nil
  }
  
  
}

extension Calculate {
  
  public func fetchAnalytics() async throws -> Analytics {
    
    guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1") else {
      throw ProductAnalyticsError.invalidURL
    }
    
    let (data, _) = try await URLSession.shared.data(from: url)
    let result = try JSONDecoder().decode(Analytics.self, from: data)
    return result
  }
}
