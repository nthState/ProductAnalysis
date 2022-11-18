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

@testable import ProductAnalysisCore
import XCTest

final class ConfigurationTests: XCTestCase {

  func testEmptyConfigurationDecodes() throws {

    let bundle = Bundle.module
    let configurationURL = bundle.url(forResource: "Resources/EmptyConfiguration", withExtension: "plist")!

    let configuration = Configuration(url: configurationURL)

    XCTAssertNotNil(configuration, "Configuration should not be nil")
  }

  func testNoConfigurationFailsToDecode() throws {

    let configuration = Configuration(url: nil)

    XCTAssertNil(configuration, "Configuration should be nil")
  }
  
  func testPathDecode() throws {
    
    let bundle = Bundle.module
    let configurationURL = bundle.url(forResource: "Resources/EmptyConfiguration", withExtension: "plist")!
    
    let plainURL = URL(string: configurationURL.path)
    
    let configuration = Configuration(url: plainURL)
    
    XCTAssertNotNil(configuration, "Configuration should not be nil")
    
  }

}
