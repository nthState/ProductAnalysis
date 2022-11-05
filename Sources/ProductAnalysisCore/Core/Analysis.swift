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
import sourcekitd

struct Call {
  let name: String
  let url: URL
  let offset: Int
}

extension Call: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(name)
    hasher.combine(url.absoluteString)
    hasher.combine(offset)
  }
}

class Analysis {

  typealias BuildMessage = String

  private let logger = Logger(subsystem: subsystem, category: "Analyse")

  private let sourceKit = SourceKit()

  private let keys: sourcekitd_keys!
  private let requests: sourcekitd_requests!
  private let values: sourcekitd_values!

  private var calls = Set<String>()
  private var newCalls = Set<Call>()
  private var expected = Set<String>()

  init() {
    keys = sourceKit.keys!
    requests = sourceKit.requests!
    values = sourceKit.values!
  }

  //  key.substructure: [
  //    {
  //      key.kind: source.lang.swift.expr.call,
  //      key.name: "Level1.Level2A.Level2AStruct",
  //      key.offset: 376,
  //      key.length: 30,
  //      key.nameoffset: 376,
  //      key.namelength: 28,
  //      key.bodyoffset: 405,
  //      key.bodylength: 0
  //    }
  //  ]
  public func analyze(analytics: Analytics, with configuration: Configuration, errorCode: inout Int) async throws -> [BuildMessage] {

    expected = extractKeys(analytics: analytics)
    logger.log("Expected Keys: \(self.expected, privacy: .public)")

    let urls = listFiles(in: configuration.projectDir)
    for url in urls {
      logger.log("Analysing file at url: \(url)")
      findFeatures(inURL: url)
    }

    let unImplemented = findUnImplemented(with: configuration)
    let duplicates = findDuplicates(with: configuration)

    let allMessages = duplicates + unImplemented

    // If there was an error, set errorCode
    errorCode = allMessages.allSatisfy({ $0.starts(with: "error:") }) ? 0 : 1

    // Write to build log
    allMessages.forEach { print($0) }

    return allMessages
  }

}

extension Analysis {

  func findUnImplemented(with configuration: Configuration) -> [BuildMessage] {

    let missing = Array(expected.subtracting(calls))
    logger.log("Missing Keys: \(missing, privacy: .public)")

    // Generate messages
    return missing.map({ generate(message: "\($0) not implemented", warningsAsErrors: configuration.warningsAsErrors) })
  }

  func findDuplicates(with configuration: Configuration) -> [BuildMessage] {

    let duplicate = Dictionary(grouping: newCalls, by: {$0.name}).filter { $1.count > 1 }.keys
    let listOfDuplicates = duplicate.map { name in
      let found = newCalls.filter { call in
        call.name == name
      }

      let usedIn = Set(found.map({ $0.url.lastPathComponent }))

      return generate(message: "\(name) duplicated in: \(usedIn)", warningsAsErrors: configuration.duplicatesAsErrors)
    }

    return listOfDuplicates
  }

}

extension Analysis {

  internal func listFiles(in url: URL) -> [URL] {
    var files = [URL]()
    if let enumerator = FileManager.default.enumerator(at: url, includingPropertiesForKeys: [.isRegularFileKey], options: [.skipsHiddenFiles, .skipsPackageDescendants]) {
      for case let fileURL as URL in enumerator {
        do {
          let fileAttributes = try fileURL.resourceValues(forKeys: [.isRegularFileKey])
          if fileAttributes.isRegularFile! {
            guard let url = URL(string: fileURL.path) else {
              continue
            }
            files.append(url)
          }
        } catch { print(error, fileURL) }
      }
    }
    return files
  }

}

extension Analysis {

  internal func extractKeys(analytics: Analytics) -> Set<String> {
    var keys = Set<String>()
    for (categoryName, category) in analytics.categories {
      for (subCategoryName, subCategory) in category {
        for child in subCategory.children {
          keys.insert("\(SourceGenerator.mainKey).\(categoryName).\(subCategoryName).\(child.name)")
        }
      }
    }
    return keys
  }

}

extension Analysis {

  internal func findFeatures(inURL url: URL) {
    let req = SKRequestDictionary(sourcekitd: sourceKit)

    req[keys.request] = requests.editor_open
    req[keys.name] = url.absoluteString
    req[keys.sourcefile] = url.absoluteString

    logger.log("SourceKit Request: \(req)")
    let response = sourceKit.sendSync(req)
    logger.log("SourceKit Response: \(response)")

    recurse(url: url, response: response)
  }

  internal func recurse(url: URL, response: SKResponseDictionary) {
    response.recurse(uid: keys.substructure) { dict in
      let kind: SKUID? = dict[self.keys.kind]
      self.recurse(url: url, response: dict)

      guard kind?.uid == self.values.expr_call else {
        return
      }

      if let name: String = dict[self.keys.name],
          let offset: Int = dict[self.keys.offset] {

        self.logger.log("Call: \(name, privacy: .public), contained in set: \(self.expected.contains(name), privacy: .public)")
        if self.expected.contains(name) {
          self.calls.insert(name)
          self.newCalls.insert(Call(name: name, url: url, offset: offset))
        }
      }
    }
  }

}

extension Analysis {

  internal func generate(message: String, warningsAsErrors: Bool) -> BuildMessage {
    let prefix = warningsAsErrors ? "error" : "warning"
    return "\(prefix): \(message)"
  }

}
