//
//  Copyright 2022 nthState Ltd. All Rights Reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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
    
    let v = Bundle.main.fullVersion
    let id = Bundle.main.bundleIdentifier
    
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

