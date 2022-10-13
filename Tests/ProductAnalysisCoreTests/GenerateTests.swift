//
//  Copyright © 2022 Chris Davis, https://www.nthState.com
//
//  See LICENSE for license information.
//

import XCTest
@testable import ProductAnalysisCore

final class ProductAnalysisCoreWriteTests: XCTestCase {
  
  func testWrite() async throws {
    
    let project = try URL(fileURLWithPath: makeTempFolder(named: UUID().uuidString).absoluteString)
    
    let bundle = Bundle.module
    let url = bundle.url(forResource: "Resources/ExampleProductKeys", withExtension: "json")!
    let calculate = DataFetcher()
    let analytics = try await calculate.fetchAnalytics(url: url)
    
    let configuration = Configuration(projectDir: project)
    
    let generate = SourceGenerator()
    _ = try await generate.write(analytics: analytics, with: configuration)
    
    let outPath = project.appendingPathComponent(SourceGenerator.folderName).appendingPathComponent(SourceGenerator.swiftFileName).absoluteString
    let exists = FileManager.default.fileExists(atPath: outPath)
    XCTAssertTrue(exists, "File should have been written")
    
    let contents = String(decoding: FileManager.default.contents(atPath: outPath)!, as: UTF8.self)
    XCTAssertNotNil(contents)
  }
}
