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

import ArgumentParser
import Foundation
import OSLog
import ProductAnalysisCore

@main
public struct CLI: AsyncParsableCommand {

  @Option(help: "Access Token used by API")
  var accessToken: String?

  @Flag(help: "Treat warnings as Errors")
  var warningsAsErrors = false

  @Flag(help: "Treat duplicates as Errors")
  var duplicatesAsErrors = false

  @Option(help: "Optional JSON file path to use instead of API")
  var jsonFilePath: String?

  @Option(help: "Folder name if you want the generated source code written somewhere other than `Analysis`")
  var folderName: String?

//  @Option(help: "API Endpoint Override")
//  var api: String?

  @Flag(help: "Enable Analysis of Source code")
  var enableAnalysis: Bool = false

  @Flag(help: "Enable sending Analysis Results")
  var enableReportAnalysisResults: Bool = false

  @Flag(help: "Enable writing Source Code")
  var enableGenerateSourceCode: Bool = false

  /**
   To enable log output, run the following command in a terminal window to stream the output
   
   log stream --level debug --predicate 'subsystem == "com.ProductAnalysis"'
   */
  lazy var logger: Logger = Logger(subsystem: subsystem, category: "Console")

  public init() {

  }

  public mutating func run() async throws {

    print("ProductAnalysis Starting")

    let service = Service()
    let configuration = getConfiguration()

    var returnCode: Int32 = 0
    do {
      returnCode = try await service.run(with: configuration)
    } catch let error {
      logger.error("Run error: \(error.localizedDescription, privacy: .public)")
    }

    print("ProductAnalysis Finished")

    if returnCode != 0 {
      throw ExitCode(returnCode)
    }
  }

  // MARK: - Build Configuration

  internal mutating func getConfiguration() -> Configuration {

    let configuration: Configuration
    if let configFromFile = Configuration(url: urlToProjectDir()) {
      logger.info("Found ProductAnalysis.plist, using it for configuration")
      configuration = configFromFile
    } else {

      logger.log("No ProductAnalysis.plist found, reading options from command line, if any")

      guard let projectDir = urlToProjectDir() else {
        fatalError("$PROJECT_DIR not found, exiting")
      }

      configuration = Configuration(warningsAsErrors: warningsAsErrors,
                                    duplicatesAsErrors: duplicatesAsErrors,
                                    accessToken: accessToken ?? "none_set",
                                    enableAnalysis: enableAnalysis,
                                    enableReportAnalysisResults: enableReportAnalysisResults,
                                    enableGenerateSourceCode: enableGenerateSourceCode,
                                    folderName: folderName,
                                    jsonURL: URL(string: jsonFilePath ?? ""),
                                    projectDir: projectDir)
    }
    return configuration
  }

  internal func urlToProjectDir() -> URL? {
    URL(fileURLWithPath: ProcessInfo.processInfo.environment["PROJECT_DIR"] ?? "")
  }

}
