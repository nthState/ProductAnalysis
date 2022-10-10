//
//  File.swift
//  
//
//  Created by Chris Davis on 10/10/2022.
//

import Foundation
import OSLog

class AnalysisReporter {
  
  private let logger = Logger(subsystem: subsystem, category: "AnalysisReporter")
  
  public init() {
    
  }
  
}

extension AnalysisReporter {
  
  @discardableResult
  public func reportAnalysis(results: [String]) async throws -> Analytics {
    
    guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1") else {
      throw ProductAnalyticsError.invalidURL
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    let (data, _) = try await URLSession.shared.data(for: request)
    let result = try JSONDecoder().decode(Analytics.self, from: data)
    return result
  }
}

