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
  
  @Flag(help: "Enable Logging")
  var enableLogging: Bool = false
  
  lazy var logger: Logger = Logger(subsystem: "com.productanalytics", category: "Console")
  
  public init() {
    
  }
  
  public mutating func run() async throws {
    //print(Foo().text)
    let x = Test()
    x.doIt()

    let configuration: ProductAnalyticsConfiguration
    if let configFromFile = findConfiguration(projectDir: urlToProjectDir()) {
      logger.log("Found ProductAnalytics.plist, using that for configuration")
      configuration = configFromFile
    } else {
      
      logger.log("No config found, reading options from command line")
      
      configuration = ProductAnalyticsConfiguration(warningsAsErrors: warningsAsErrors,
                                                    accessToken: accessToken ?? "none_set",
                                                    enableLogging: enableLogging)
    }
    
    x.run(with: configuration)
    
    do {
      let foo = try await x.fetch()
    } catch let error {
      logger.log("has error: \(error.localizedDescription, privacy: .public)")
    }
    
  }
  
  internal func urlToProjectDir() -> URL? {
    URL(string: ProcessInfo.processInfo.environment["PROJECT_DIR"] ?? "")
  }
  
  private mutating func findConfiguration(projectDir: URL?) -> ProductAnalyticsConfiguration? {
    
    guard let projectDir else {
      logger.log("projectDir is nil")
      return nil
    }
    
    let configurationURL = projectDir.appendingPathComponent("ProductAnalytics.plist")
    
    logger.log("Looking for file: \(configurationURL)")
    
    guard FileManager.default.fileExists(atPath: configurationURL.absoluteString) else {
      logger.log("Can't find \(configurationURL)")
      return nil
    }
    
    guard FileManager.default.isReadableFile(atPath: configurationURL.absoluteString) else {
      logger.log("File not readable \(configurationURL)")
      return nil
    }
    
    guard let data = FileManager.default.contents(atPath: configurationURL.absoluteString) else {
      logger.log("Can't get data of \(configurationURL)")
      return nil
    }
    
    let decoder = PropertyListDecoder()
    return try? decoder.decode(ProductAnalyticsConfiguration.self, from: data)
  }
}
