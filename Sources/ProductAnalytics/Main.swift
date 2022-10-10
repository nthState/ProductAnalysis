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
    
    let service = Service()
    let configuration = getConfiguration()
    
    do {
      try await service.run(with: configuration)
    } catch let error {
      logger.log("has error: \(error.localizedDescription, privacy: .public)")
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
      
      configuration = Configuration(warningsAsErrors: warningsAsErrors,
                                    accessToken: accessToken ?? "none_set",
                                    enableAnalysis: enableAnalysis,
                                    reportAnalysisResults: reportAnalysisResults,
                                    generateSourceCode: generateSourceCode,
                                    outputFolder: outputFolder,
                                    jsonURL: URL(string: jsonFilePath ?? ""))
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
    
    let configurationURL = projectDir.appendingPathComponent("ProductAnalytics.plist")
    
    logger.log("Looking for file at url: \(configurationURL, privacy: .public)")
    
    guard FileManager.default.fileExists(atPath: configurationURL.absoluteString) else {
      logger.log("Can't find url: \(configurationURL, privacy: .public)")
      return nil
    }
    
    guard FileManager.default.isReadableFile(atPath: configurationURL.absoluteString) else {
      logger.log("File not readable: \(configurationURL, privacy: .public)")
      return nil
    }
    
    guard let data = FileManager.default.contents(atPath: configurationURL.absoluteString) else {
      logger.log("Can't get data of: \(configurationURL, privacy: .public)")
      return nil
    }
    
    let decoder = PropertyListDecoder()
    do {
      return try decoder.decode(Configuration.self, from: data)
    } catch let error {
      logger.log("Unable to decode Plist: \(error.localizedDescription, privacy: .public)")
      throw error
    }
  }
}
