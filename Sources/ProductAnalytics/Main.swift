import ProductAnalyticsCore
import ArgumentParser
import Foundation

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
  
  public init() {
    
  }
  
  public mutating func run() async throws {
    //print(Foo().text)
    let x = Test()
    x.doIt()
    
    print("warningsAsErrors: \(warningsAsErrors)")
    print("outputFolder: \(String(describing: outputFolder))")
    
    if let value = ProcessInfo.processInfo.environment["PROJECT_DIR"] {
      print("PROJECT_DIR: \(value)")
      
      print("findConfiguration: \(String(describing: findConfiguration(projectDir: URL(string: value))))")
    }
    
    do {
      let foo = try await x.fetch()
    } catch let error {
      print("has error")
      print(error.localizedDescription)
    }
    
  }
  
  private func findConfiguration(projectDir: URL?) -> ProductAnalyticsConfiguration? {
    
    guard let projectDir else {
      print("projectDir is nil")
      return nil
    }
    
    let configurationURL = projectDir.appendingPathComponent("ProductAnalytics.plist")
    
    guard FileManager.default.fileExists(atPath: configurationURL.absoluteString) else {
      print("Can't find \(configurationURL)")
      return nil
    }
    
    print("Looking for file: \(configurationURL)")

    guard let data = try? Data(contentsOf: configurationURL) else {
      print("Data not read")
      return nil
    }
    
    let decoder = PropertyListDecoder()
    return try? decoder.decode(ProductAnalyticsConfiguration.self, from: data)
  }
}

struct ProductAnalyticsConfiguration: Decodable {
  let warningsAsErrors: Bool
}
