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

class DataFetcher {

  private let logger = Logger(subsystem: subsystem, category: "Calculate")

  func fetch(with configuration: Configuration) async throws -> Analytics {

    let url: URL
    if let overrideURL = configuration.jsonURL {
      logger.log("Using JSON override URL: \(overrideURL)")
      url = overrideURL
    } else {
      logger.log("Calling API to fetch JSON")
      url = URL(string: "https://raw.githubusercontent.com/nthState/ProductAnalysis/main/Tests/ProductAnalysisCoreTests/Resources/ExampleProductKeys.json")!
    }

    return try await fetchAnalytics(url: url)
  }

}

extension DataFetcher {

  internal func fetchAnalytics(url: URL) async throws -> Analytics {

    let version = Bundle.main.fullVersion
    let identifier = Bundle.main.bundleIdentifier

    let result: Analytics
    do {
      let (data, _) = try await URLSession.shared.data(from: url)
      result = try JSONDecoder().decode(Analytics.self, from: data)
    } catch let error {
      logger.error("fetch Analytics error: \(error.localizedDescription, privacy: .public)")
      throw error
    }

    return result
  }
}
