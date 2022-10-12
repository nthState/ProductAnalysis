//
//  Copyright © 2022 Chris Davis, https://www.nthState.com
//
//  See LICENSE for license information.
//

import Foundation
import OSLog
import sourcekitd

class Analyse {
  
  private let logger = Logger(subsystem: subsystem, category: "Analyse")
  
  let sourceKit = SourceKit()
  
  let keys: sourcekitd_keys!
  let requests: sourcekitd_requests!
  let values: sourcekitd_values!
  
  var calls = Set<String>()
  
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
   */
  
  func run(analytics: Analytics, with configuration: Configuration) async throws -> [String] {
    logger.log("In Analyse")
    
    let files = listFiles(in: configuration.projectDir)
    for file in files {
      logger.log("Analyse file: \(file)")
      findFeatures(inFile: file.absoluteString)
    }
    
    let expected: Set<String> = extractKeys(analytics: analytics)
    
    // We want only the calls that are not found:
    // https://www.programiz.com/swift-programming/sets
    let missing = Array(expected.subtracting(calls))
    logger.log("Missing Keys: \(missing)")
    
    // Generate messages
    let m = missing.map({ generate(message: "\($0) not implemented", warningsAsErrors: configuration.warningsAsErrors) })
    
    // Write to build log
    m.forEach { message in
      print(message)
    }
    
    return m
  }
  
}

extension Analyse {
  
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

extension Analyse {
  
  internal func extractKeys(analytics: Analytics) -> Set<String> {
    var keys = Set<String>()
    for (categoryName, category) in analytics.categories {
      for (subCategoryName, subCategory) in category {
        for child in subCategory.children {
          keys.insert("\(categoryName).\(subCategoryName).\(child.name)")
        }
      }
    }
    return keys
  }
  
}

extension Analyse {
  
  func findFeatures(inFile file: String) {
    let req = SKRequestDictionary(sourcekitd: sourceKit)
    
    req[keys.request] = requests.editor_open
    req[keys.name] = file
    req[keys.sourcefile] = file
    
    logger.log("Request: \(req)")
    let response = sourceKit.sendSync(req)
    logger.log("Response: \(response)")
    
    recurse(response: response)
    
    calls.forEach({ print("Found: \($0)") })
  }
  
  func recurse(response: SKResponseDictionary) {
    response.recurse(uid: keys.substructure) { dict in
      let kind: SKUID? = dict[self.keys.kind]
      self.recurse(response: dict)
      
      guard kind?.uid == self.values.expr_call else {
        return
      }
      
      let name: String? = dict[self.keys.name]
      if name == "Level1.Level2A.Level2AStruct" {
        self.calls.insert(name!)
      }
    }
  }
  
}

extension Analyse {
  
  internal func generate(message: String, warningsAsErrors: Bool) -> String {
    let prefix = warningsAsErrors ? "error" : "warning"
    return "\(prefix): \(message)"
  }
  
}

