//
//  File.swift
//  
//
//  Created by Chris Davis on 08/10/2022.
//

import Foundation
import OSLog

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
  
  func run(analytics: Analytics, with configuration: Configuration) async -> [String] {
    return []
  }
  
}

extension Analyse {
  func findFeatures(inFile file: String) -> [String] {
    let req = SKRequestDictionary(sourcekitd: sourceKit)
    
    req[keys.request] = requests.editor_open
    req[keys.name] = file
    req[keys.sourcefile] = file
    
    let response = sourceKit.sendSync(req)
    
    var features = [String]()
    response.recurse(uid: keys.substructure) { dict in
      let kind: SKUID? = dict[self.keys.kind]
      guard kind?.uid == self.values.decl_enum else {
        return
      }
      guard let inheritedtypes: SKResponseArray = dict[self.keys.inheritedtypes] else {
        return
      }
      for inheritance in (0..<inheritedtypes.count).map({ inheritedtypes.get($0) }) {
        if let name: String = inheritance[self.keys.name], name == "Feature" {
          features.append(name)
        }
      }
    }
    
    return features
  }
}

extension Analyse {
  
  func run(events: [String], with configuration: Configuration) {
    
    logger.log("In Analyse")
    
    log(message: "test", warningsAsErrors: configuration.warningsAsErrors)
  }
  
  /**
   Note: This `print` statement is required so that it emits into the build stream
   */
  func log(message: String, warningsAsErrors: Bool) {
    let prefix = warningsAsErrors ? "error" : "warning"
    print("\(prefix): \(message)")
  }
  
}

