//
//  Copyright © 2022 Chris Davis, https://www.nthState.com
//
//  See LICENSE for license information.
//

import Foundation
import OSLog
import sourcekitd

struct Call {
  let name: String
  let file: String
  let line: Int
}

extension Call: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(name)
    hasher.combine(file)
    hasher.combine(line)
  }
}

class Analysis {
  
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
  
  /**
   Loop the file, and find all call sites of all analytics keys
   If found,
   log key found ok
   if not found
   write to build log as either warning or error
   
   - returns: List of messages for build results
   */
  public func analyze(analytics: Analytics, with configuration: Configuration, errorCode: inout Int) async throws -> [String] {

    expected = extractKeys(analytics: analytics)
    logger.log("Expected Keys: \(self.expected, privacy: .public)")
    
    let files = listFiles(in: configuration.projectDir)
    for file in files {
      logger.log("Analyse file: \(file)")
      findFeatures(inFile: file.absoluteString)
    }
    
    // What have we found?
    calls.forEach({ print("Found: \($0)") })
    
    // We want only the calls that are not found:
    // https://www.programiz.com/swift-programming/sets
    let missing = Array(expected.subtracting(calls))
    logger.log("Missing Keys: \(missing, privacy: .public)")
    
    // Generate messages
    let m = missing.map({ generate(message: "\($0) not implemented", warningsAsErrors: configuration.warningsAsErrors) })
    
    errorCode = m.first { message in
      message.starts(with: "error:")
    }?.count ?? 0
    
    // Write to build log
    m.forEach { message in
      print(message)
    }
    
    return m
  }
  
}

extension Analysis {
  
  internal func listFiles(in url: URL) -> [URL] {
    var files = [URL]()
    if let enumerator = FileManager.default.enumerator(at: url, includingPropertiesForKeys: [.isRegularFileKey], options: [.skipsHiddenFiles, .skipsPackageDescendants]) {
      for case let fileURL as URL in enumerator {
        do {
          let fileAttributes = try fileURL.resourceValues(forKeys:[.isRegularFileKey])
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
  
  internal func findFeatures(inFile file: String) {
    let req = SKRequestDictionary(sourcekitd: sourceKit)
    
    req[keys.request] = requests.editor_open
    req[keys.name] = file
    req[keys.sourcefile] = file
    
    logger.log("SourceKit Request: \(req)")
    let response = sourceKit.sendSync(req)
    logger.log("SourceKit Response: \(response)")
    
    recurse(file: file, response: response)
  }
  
  internal func recurse(file: String, response: SKResponseDictionary) {
    response.recurse(uid: keys.substructure) { dict in
      let kind: SKUID? = dict[self.keys.kind]
      self.recurse(file: file, response: dict)
      
      guard kind?.uid == self.values.expr_call else {
        return
      }
      
      if let name: String = dict[self.keys.name], let line: Int = dict[self.keys.offset] {

        self.logger.log("Call: \(name, privacy: .public), contained in set: \(self.expected.contains(name), privacy: .public)")
        if self.expected.contains(name) {
          self.calls.insert(name)
          
          self.newCalls.insert(Call(name: name, file: file, line: line))
          
        }
      }
    }
  }
  
}

extension Analysis {
  
  internal func generate(message: String, warningsAsErrors: Bool) -> String {
    let prefix = warningsAsErrors ? "error" : "warning"
    return "\(prefix): \(message)"
  }
  
}

