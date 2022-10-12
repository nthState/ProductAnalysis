//
//  Copyright © 2022 Chris Davis, https://www.nthState.com
//
//  See LICENSE for license information.
//

import ProductAnalyticsCore
import ArgumentParser
import Foundation
import OSLog

@main
public struct Main: ParsableCommand, AsyncParsableCommand{
  
  @Option(help: "Access Token")
  var accessToken: String?
  
  @Flag(help: "Treat warnings as Errors")
  var warningsAsErrors = false
  
  @Option(help: "JSON File Override")
  var jsonFilePath: String?
  
  @Option(help: "Output Folder")
  var outputFolder: String?
  
  @Option(help: "API Endpoint Override")
  var api: String?
  
  @Option(help: "Optional Project Name")
  var projectName: String?
  
  @Flag(help: "Enable Analysis")
  var enableAnalysis: Bool = false
  
  @Flag(help: "Report Analysis Results")
  var reportAnalysisResults: Bool = false
  
  @Flag(help: "Generate Source Code")
  var generateSourceCode: Bool = false
  
  
  /**
   To enable log output, run the following command in a terminal window to stream the output
   
   log stream --level debug --predicate 'subsystem == "com.productanalytics"'
   */
  lazy var logger: Logger = Logger(subsystem: subsystem, category: "Console")
  
  public init() {
    
  }
  
  public mutating func run() async throws {
    
    print("ProductAnalytics Starting")
    
    let service = Service()
    let configuration = getConfiguration()
    
    do {
      try await service.run(with: configuration)
    } catch let error {
      logger.error("Run error: \(error.localizedDescription, privacy: .public)")
    }
    
    print("ProductAnalytics Finished")
  }
  
  // MARK: - Build Configuration
  
  internal mutating func getConfiguration() -> Configuration {
    let configuration: Configuration
    if let configFromFile = findConfiguration(projectDir: urlToProjectDir()) {
      logger.info("Found ProductAnalytics.plist, using it for configuration")
      configuration = configFromFile
    } else {
      
      logger.log("No ProductAnalytics.plist found, reading options from command line, if any")
      
      guard let projectDir = urlToProjectDir() else {
        fatalError("$PROJECT_DIR not found, exiting")
      }
      
      configuration = Configuration(warningsAsErrors: warningsAsErrors,
                                    accessToken: accessToken ?? "none_set",
                                    enableAnalysis: enableAnalysis,
                                    reportAnalysisResults: reportAnalysisResults,
                                    generateSourceCode: generateSourceCode,
                                    folderName: nil,
                                    jsonURL: URL(string: jsonFilePath ?? ""),
                                    projectDir: projectDir)
    }
    return configuration
  }
  
  internal func urlToProjectDir() -> URL? {
    URL(string: ProcessInfo.processInfo.environment["PROJECT_DIR"] ?? "")
  }
  
  internal mutating func findConfiguration(projectDir: URL?) -> Configuration? {
    
    guard let projectDir else {
      logger.log("Xcode environment variable $PROJECT_DIR is nil")
      return nil
    }
    
    guard let configurationURL = findFile(named: "ProductAnalytics.plist", at: projectDir) else {
      logger.log("Can't find ProductAnalytics.plist")
      return nil
    }
    
//    let configurationURL = projectDir.appendingPathComponent("ProductAnalytics.plist")
//    let configurationPath = configurationURL.absoluteString
//
//    logger.log("Looking for file at url: \(configurationURL, privacy: .public)")
//
//    guard FileManager.default.fileExists(atPath: configurationPath) else {
//      logger.log("Can't find url: \(configurationURL, privacy: .public)")
//      return nil
//    }
//
//    guard FileManager.default.isReadableFile(atPath: configurationPath) else {
//      logger.log("File not readable: \(configurationURL, privacy: .public)")
//      return nil
//    }
    
    guard let data = FileManager.default.contents(atPath: configurationURL.absoluteString) else {
      logger.log("Can't get data of: \(configurationURL, privacy: .public)")
      return nil
    }
    
    let decoder = PropertyListDecoder()
    do {
      return try decoder.decode(Configuration.self, from: data)
    } catch let error {
      logger.error("Unable to decode Plist: \(error.localizedDescription, privacy: .public)")
      return nil
    }
  }
  
  internal func findFile(named: String, at url: URL) -> URL? {
    if let enumerator = FileManager.default.enumerator(at: url, includingPropertiesForKeys: [.isRegularFileKey], options: [.skipsHiddenFiles, .skipsPackageDescendants]) {
      for case let fileURL as URL in enumerator {
        do {
          let fileAttributes = try fileURL.resourceValues(forKeys:[.isRegularFileKey])
          if fileAttributes.isRegularFile! {
            guard let url = URL(string: fileURL.path) else {
              continue
            }
            if url.lastPathComponent == named {
              return url
            }
          }
        } catch { print(error, fileURL) }
      }
    }
    return nil
  }
}
