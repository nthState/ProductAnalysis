//
//  File.swift
//  
//
//  Created by Chris Davis on 08/10/2022.
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
  
  func run(url: URL, analytics: Analytics, with configuration: Configuration) async -> [String] {
    logger.log("In Analyse")
    
    /**
     Note: We could take a flattened list here instead
     
     Loop the file, and find all call sites of all analytics keys
     If found,
        log key found ok
      if not found
          write to build log as either warning or error
     */
    
    let _ = findFeatures(inFile: url.absoluteString)
    
    let expected: Set<String> = ["Level1.Level2A.Level2AStruct", "Level1.Level2B.Level2BStruct"]
    
    // We want only the calls that are not found:
    // https://www.programiz.com/swift-programming/sets
    let missing = Array(expected.subtracting(calls))
    
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
  
  func findFeatures(inFile file: String) -> [String] {
    let req = SKRequestDictionary(sourcekitd: sourceKit)
    
    req[keys.request] = requests.editor_open
    req[keys.name] = file
    req[keys.sourcefile] = file
    
    logger.log("Request: \(req)")
    let response = sourceKit.sendSync(req)
    logger.log("Response: \(response)")
    
    
    recurse(response: response)
    
    calls.forEach({ print("Found: \($0)") })
    
    return []
  }
  
  func recurse(response: SKResponseDictionary) {
    response.recurse(uid: keys.substructure) { dict in
      let kind: SKUID? = dict[self.keys.kind]
      //let name = dict[self.keys.name]
      //print("Found Kind: \(kind)")
      self.recurse(response: dict)
      
      guard kind?.uid == self.values.expr_call else {
        return
      }
      
      let name: String? = dict[self.keys.name]

      print("found call: \(String(describing: name))")

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

