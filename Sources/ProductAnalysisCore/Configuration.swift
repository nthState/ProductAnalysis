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

import Foundation
import OSLog

public struct Configuration: Decodable {
  public let warningsAsErrors: Bool
  public let duplicatesAsErrors: Bool
  public let accessToken: String
  public let enableAnalysis: Bool
  public let enableReportAnalysisResults: Bool
  public let enableGenerateSourceCode: Bool
  public let folderName: String?
  public let jsonURL: URL?
  public var projectDir: URL
  
  private static var logger: Logger = Logger(subsystem: subsystem, category: "Configuration")

  // MARK: - Constructor

  public init(warningsAsErrors: Bool = false,
              duplicatesAsErrors: Bool = false,
              accessToken: String = "",
              enableAnalysis: Bool = true,
              enableReportAnalysisResults: Bool = true,
              enableGenerateSourceCode: Bool = true,
              folderName: String? = nil,
              jsonURL: URL? = nil,
              projectDir: URL) {
    self.warningsAsErrors = warningsAsErrors
    self.duplicatesAsErrors = duplicatesAsErrors
    self.accessToken = accessToken
    self.enableAnalysis = enableAnalysis
    self.enableReportAnalysisResults = enableReportAnalysisResults
    self.enableGenerateSourceCode = enableGenerateSourceCode
    self.folderName = folderName
    self.jsonURL = jsonURL
    self.projectDir = projectDir
  }
  
  public init?(url projectDir: URL?) {
    
    guard let projectDir else {
      Configuration.logger.log("Xcode environment variable $PROJECT_DIR is nil")
      return nil
    }

    let configurationURL: URL
    if !projectDir.isFileURL {
      guard let configURL = Configuration.findFile(named: "ProductAnalysis.plist", at: projectDir) else {
        Configuration.logger.log("Can't find ProductAnalysis.plist")
        return nil
      }
      configurationURL = configURL
    } else {
      configurationURL = projectDir
    }

    //guard let data = FileManager.default.contents(atPath: configurationURL.absoluteString) else {
    guard let data = try? Data(contentsOf: configurationURL) else {
      Configuration.logger.log("Can't get data of: \(configurationURL, privacy: .public)")
      return nil
    }

    let decoder = PropertyListDecoder()
    do {
      var configuration = try decoder.decode(Configuration.self, from: data)
      configuration.projectDir = configurationURL.deletingLastPathComponent()
      self = configuration
    } catch let error {
      Configuration.logger.error("Unable to decode Plist: \(error.localizedDescription, privacy: .public)")
      return nil
    }
  }

  // MARK: - Decodable from PLIST

  enum CodingKeys: CodingKey {
    case warningsAsErrors
    case duplicatesAsErrors
    case accessToken
    case enableAnalysis
    case enableReportAnalysisResults
    case enableGenerateSourceCode
    case folderName
    case jsonURL
    case projectDir
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.warningsAsErrors = try container.decodeIfPresent(Bool.self, forKey: .warningsAsErrors) ?? false
    self.duplicatesAsErrors = try container.decodeIfPresent(Bool.self, forKey: .duplicatesAsErrors) ?? false
    self.accessToken = try container.decodeIfPresent(String.self, forKey: .accessToken) ?? "none_set"
    self.enableAnalysis = try container.decodeIfPresent(Bool.self, forKey: .enableAnalysis) ?? true
    self.enableReportAnalysisResults = try container.decodeIfPresent(Bool.self, forKey: .enableReportAnalysisResults) ?? true
    self.enableGenerateSourceCode = try container.decodeIfPresent(Bool.self, forKey: .enableGenerateSourceCode) ?? true
    self.folderName = try container.decodeIfPresent(String.self, forKey: .folderName)
    self.jsonURL = try container.decodeIfPresent(URL.self, forKey: .jsonURL)
    self.projectDir = URL(string: ProcessInfo.processInfo.environment["PROJECT_DIR"] ?? "none_set")!
  }
}

extension Configuration: CustomStringConvertible {
  public var description: String {
    return """
      warningsAsErrors: \(warningsAsErrors)
      duplicatesAsErrors: \(duplicatesAsErrors)
      accessToken: \(accessToken)
      enableAnalysis: \(enableAnalysis)
      enableReportAnalysisResults: \(enableReportAnalysisResults)
      enableGenerateSourceCode: \(enableGenerateSourceCode)
      folderName: \(String(describing: folderName))
      jsonURL: \(String(describing: jsonURL))
      projectDir: \(String(describing: projectDir))
      """
  }
}

extension Configuration {
  internal static func findFile(named: String, at url: URL) -> URL? {
    if let enumerator = FileManager.default.enumerator(at: url, includingPropertiesForKeys: [.isRegularFileKey], options: [.skipsHiddenFiles, .skipsPackageDescendants]) {
      for case let fileURL as URL in enumerator {
        do {
          let fileAttributes = try fileURL.resourceValues(forKeys: [.isRegularFileKey])
          if fileAttributes.isRegularFile! {
            guard let url = URL(string: fileURL.path) else {
              continue
            }
            if url.lastPathComponent == named {
              return url
            }
          }
        } catch {
          Configuration.logger.error("\(error.localizedDescription, privacy: .public) \(fileURL)")
        }
      }
    }
    return nil
  }
}
