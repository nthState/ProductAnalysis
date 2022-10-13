//
//  Copyright © 2022 Chris Davis, https://www.nthState.com
//
//  See LICENSE for license information.
//

import Foundation
import OSLog

enum ProductAnalysisError: Error {
  case invalidURL
}

class AnalysisReporter {
  
  private let logger = Logger(subsystem: subsystem, category: "AnalysisReporter")

}

extension AnalysisReporter {
  
  @discardableResult
  public func report(results: [String], with configuration: Configuration) async throws -> String {
    
    guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1") else {
      throw ProductAnalysisError.invalidURL
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    let result: String
    do {
      let (data, _) = try await URLSession.shared.data(for: request)
      result = try JSONDecoder().decode(String.self, from: data)
    } catch let error {
      logger.error("AnalysisReporter error: \(error.localizedDescription, privacy: .public)")
      throw error
    }
    return result
  }
}

