import XCTest
@testable import ProductAnalyticsCore

final class AnalysisTests: XCTestCase {
  
  func testAnalysis() async throws {
    
    let outputFolder = URL(fileURLWithPath: NSTemporaryDirectory().appending("MyRootOutput"))
    let project = URL(fileURLWithPath: NSTemporaryDirectory().appending("MyRootProject"))
    
    let bundle = Bundle.module
    let url = URL(string: bundle.url(forResource: "SemiImplemented", withExtension: "txt")!.path)!
    //let url = URL(string: "/Users/chrisdavis/Documents/Projects/ProductAnalytics/Sources/ProductAnalytics/Main.swift")!
    
    print(url)
    
    let configuration = Configuration(warningsAsErrors: false, accessToken: "", enableAnalysis: true, reportAnalysisResults: true, generateSourceCode: true, outputFolder: outputFolder, jsonURL: nil, projectDir: project)
    
    var analytics = Analytics(categories: ["Level1" : [
      "Level2A" : SubCategory(children: [Child(name: "Level2AStruct", value: "")]),
      "Level2B" : SubCategory(children: [])
    ]])
    
    
    let analysis = Analyse()
    let results = await analysis.run(url: url, analytics: analytics, with: configuration)
    
    let expected: [String] = [
      "warning: Level2AStruct not implemented"
    ]
    
    XCTAssertEqual(results, expected, "Analysis results should match")
  }
  
}
