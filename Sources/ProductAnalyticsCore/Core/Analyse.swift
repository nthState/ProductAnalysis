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
    
    return []
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
    
    var log = [String]()
    recurse(response: response)
//    response.recurse(uid: keys.substructure) { dict in
//      let kind: SKUID? = dict[self.keys.kind]
//      print("Found Kind: \(kind)")
//
//      //kind?.uid == self.keys.
////      guard kind?.uid == self.values.decl_enum else {
////        return
////      }
////      guard let inheritedtypes: SKResponseArray = dict[self.keys.inheritedtypes] else {
////        return
////      }
////      for inheritance in (0..<inheritedtypes.count).map({ inheritedtypes.get($0) }) {
////        if let name: String = inheritance[self.keys.name], name == "Feature" {
////          features.append(name)
////        }
////      }
//    }
    
    return log
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

      print("found call: \(name)")
//      guard let inheritedtypes: SKResponseArray = dict[self.keys.inheritedtypes] else {
//        return
//      }
//      for inheritance in (0..<inheritedtypes.count).map({ inheritedtypes.get($0) }) {
//        if let name: String = inheritance[self.keys.name], name == "Feature" {
//          features.append(name)
//        }
//      }
    }
  }
  
}

extension Analyse {
  
//  func run(events: [String], with configuration: Configuration) {
//
//    logger.log("In Analyse")
//
//    writeToBuildLog(message: "test", warningsAsErrors: configuration.warningsAsErrors)
//  }
  
  /**
   Note: This `print` statement is required so that it emits into the build stream
   */
  internal func writeToBuildLog(message: String, warningsAsErrors: Bool) {
    let prefix = warningsAsErrors ? "error" : "warning"
    print("\(prefix): \(message)")
  }
  
}

