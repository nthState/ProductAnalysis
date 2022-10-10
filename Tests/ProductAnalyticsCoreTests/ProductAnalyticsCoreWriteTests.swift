import XCTest
@testable import ProductAnalyticsCore

final class ProductAnalyticsCoreWriteTests: XCTestCase {
  
  func testWrite() async throws {
    
    let outputFolder = URL(fileURLWithPath: NSTemporaryDirectory().appending("MyRootOutput"))
    let project = URL(fileURLWithPath: NSTemporaryDirectory().appending("MyRootProject"))
    
    let bundle = Bundle.module
    let url = bundle.url(forResource: "ExampleProductKeys", withExtension: "json")!
    let calculate = Calculate()
    let analytics = try await calculate.fetchAnalytics(url: url)
    
    let configuration = Configuration(warningsAsErrors: false, accessToken: "", enableAnalysis: true, reportAnalysisResults: true, generateSourceCode: true, outputFolder: outputFolder, jsonURL: nil, projectDir: project)
    
    let generate = Generate()
    let result = try await generate.run(analytics: analytics, with: configuration)
    
    let outPath = outputFolder.appendingPathComponent(Generate.swiftFileName).absoluteString
    let exists = FileManager.default.fileExists(atPath: outPath)
    XCTAssertTrue(exists, "File should have been written")
    
    let contents = FileManager.default.contents(atPath: outPath)
    XCTAssertEqual(contents, "Nothing yet".data(using: .utf8), "Data should match")
  }
}
