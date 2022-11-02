//
//  Copyright © 2022 Chris Davis, https://www.nthState.com
//
//  See LICENSE for license information.
//

import XCTest
@testable import ProductAnalysisCore

final class AnalysisTests: XCTestCase {
  
  // TODO: What can be done about the prefix of AnalyticKeys.
  func testAnalysis() async throws {
    
    let project = try URL(fileURLWithPath: makeTempFolder(named: UUID().uuidString).absoluteString)
    
    let bundle = Bundle.module
    let url = bundle.url(forResource: "Resources/SemiImplemented", withExtension: "swift")!
    
    try FileManager.default.copyItem(at: url, to: project.appendingPathComponent("a.swift"))
    
    let proj = URL(string: project.path)!
    
    let configuration = Configuration(projectDir: proj)
    
    
    let analytics = Analytics(categories: ["Level1" : [
      "Level2A" : SubCategory(children: [Child(name: "Level2AStruct", value: "")]),
      "Level2B" : SubCategory(children: [Child(name: "Level2BStruct", value: "")])
    ]])
    
    
    let analysis = Analysis()
    var errorCode: Int = 0
    let results = try await analysis.analyze(analytics: analytics, with: configuration, errorCode: &errorCode)
    
    let expected: [String] = [
      "warning: AnalysisKeys.Level1.Level2B.Level2BStruct not implemented"
    ]
    
    XCTAssertEqual(results, expected, "Analysis results should match")
  }
  
  func testDefinedNotUsed() async throws {
    
    let project = try URL(fileURLWithPath: makeTempFolder(named: UUID().uuidString).absoluteString)
    
    let bundle = Bundle.module
    let url = bundle.url(forResource: "Resources/DefinedNotUsed", withExtension: "swift")!
    
    try FileManager.default.copyItem(at: url, to: project.appendingPathComponent("a.swift"))
    
    let proj = URL(string: project.path)!
    
    let configuration = Configuration(projectDir: proj)
    
    let analytics = Analytics(categories: ["Level1" : [
      "Level2A" : SubCategory(children: [Child(name: "Level2AStruct", value: "")]),
      "Level2B" : SubCategory(children: [Child(name: "Level2BStruct", value: "")])
    ]])
    
    
    let analysis = Analysis()
    var errorCode: Int = 0
    let results = try await analysis.analyze(analytics: analytics, with: configuration, errorCode: &errorCode)
    
    let expected: [String] = [
      "warning: AnalysisKeys.Level1.Level2A.Level2AStruct not implemented", // TODO: Extract as a template string
      "warning: AnalysisKeys.Level1.Level2B.Level2BStruct not implemented",
    ]
    
    XCTAssertEqual(results.sorted(), expected.sorted(), "Analysis results should match")
  }
  
  func test_duplicated_keys() async throws {
    
    let project = try URL(fileURLWithPath: makeTempFolder(named: UUID().uuidString).absoluteString)
    
    let bundle = Bundle.module
    let url = bundle.url(forResource: "Resources/DuplicatedImplementation", withExtension: "swift")!
    
    try FileManager.default.copyItem(at: url, to: project.appendingPathComponent("a.swift"))
    
    let proj = URL(string: project.path)!
    
    let configuration = Configuration(duplicatesAsErrors: true, projectDir: proj)
    
    
    let analytics = Analytics(categories: ["Level1" : [
      "Level2A" : SubCategory(children: [Child(name: "Level2AStruct", value: "")]),
      "Level2B" : SubCategory(children: [Child(name: "Level2BStruct", value: "")])
    ]])
    
    
    let analysis = Analysis()
    var errorCode: Int = 0
    let results = try await analysis.analyze(analytics: analytics, with: configuration, errorCode: &errorCode)
    
    let expected: [String] = [
      "error: AnalysisKeys.Level1.Level2A.Level2AStruct duplicated in: [\"a.swift\"]",
      "warning: AnalysisKeys.Level1.Level2B.Level2BStruct not implemented"
    ]
    
    XCTAssertEqual(results, expected, "Analysis results should match")
    XCTAssertEqual(errorCode, 1, "Program should have exited status code 1")
  }
  
}
