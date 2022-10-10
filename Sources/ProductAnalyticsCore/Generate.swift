//
//  File.swift
//  
//
//  Created by Chris Davis on 08/10/2022.
//

import Foundation
import OSLog

class Generate {
  
  static let swiftFileName = "Analytics.generated.swift"
  
  private let logger = Logger(subsystem: subsystem, category: "Generate")
  
  public func run(analytics: Analytics, with configuration: Configuration) async throws -> String {
    
    let dst: URL = configuration.outputFolder ?? URL(string: "no_idea")!
    
    var isDirectory: ObjCBool = false
    if !FileManager.default.fileExists(atPath: dst.absoluteString, isDirectory: &isDirectory) {
      logger.log("Creating folder: \(dst, privacy: .public)")
      try FileManager.default.createDirectory(atPath: dst.absoluteString, withIntermediateDirectories: true)
    }
    
    let swift = dst.appendingPathComponent(Generate.swiftFileName)
    
    // TODO: Need project dir here
    
    logger.log("In Generate: \(swift, privacy: .public)")
    
    let string = generate(with: analytics)
    
    let created = FileManager.default.createFile(atPath: swift.absoluteString, contents: string.data(using: .utf8))
    logger.log("File written?: \(created, privacy: .public)")
    
    return string
  }
  
  internal func generate(with: Analytics) -> String {
    return "Nothing yet"
  }

}
