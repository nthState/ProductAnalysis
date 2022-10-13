//
//  Copyright © 2022 Chris Davis, https://www.nthState.com
//
//  See LICENSE for license information.
//

import Foundation
import OSLog

class SourceGenerator {
  
  static let swiftFileName = "Analysis.generated.swift"
  static let folderName = "Analysis"
  static let mainKey = "AnalysisKeys"
  static let protocolName = "Analyzable"
  
  private let logger = Logger(subsystem: subsystem, category: "Generate")
  
  public func write(analytics: Analytics, with configuration: Configuration) async throws {
    
    let base: URL = configuration.projectDir
    let folderName = configuration.folderName ?? SourceGenerator.folderName
    let dst = base.appendingPathComponent(folderName)
    
    var isDirectory: ObjCBool = false
    if !FileManager.default.fileExists(atPath: dst.absoluteString, isDirectory: &isDirectory) {
      logger.log("Creating folder: \(dst, privacy: .public)")
      try FileManager.default.createDirectory(atPath: dst.absoluteString, withIntermediateDirectories: true)
    }
    
    generateSwift(root: dst, analytics: analytics)
  }
  
  internal func generateSwift(root dst: URL, analytics: Analytics) {
    let swift = dst.appendingPathComponent(SourceGenerator.swiftFileName)
    
    let string = generate(with: analytics)
    
    let created = FileManager.default.createFile(atPath: swift.absoluteString, contents: string.data(using: .utf8))
    logger.log("File written?: \(created, privacy: .public)")
  }
  
  internal func generate(with analytics: Analytics) -> String {
    var str = ""
    
    str.append("""
    protocol \(SourceGenerator.protocolName) { \n
         var analysisKey: String { get } \n
    } \n
    """)
    
    str.append("enum \(SourceGenerator.mainKey) {\n")
    for (categoryName, category) in analytics.categories {
      str.append("enum \(categoryName) {\n")
      for (subCategoryName, subCategory) in category {
        str.append("enum \(subCategoryName) {\n")
        for child in subCategory.children {
          
          str.append("public struct \(child.name): \(SourceGenerator.protocolName) {\n")
          
          str.append("let analysisKey: String = \"\(child.value)\"\n")
          
          // TODO: Properties
          
          str.append("}\n")
          
        }
        str.append("}\n")
      }
      str.append("}\n")
    }
    str.append("}\n")
    
    return str
  }
  
}
