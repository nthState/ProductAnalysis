//
//  Copyright 2022 nthState Ltd. All Rights Reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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
