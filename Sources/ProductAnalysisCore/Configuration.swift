//
//  Copyright © 2022 Chris Davis, https://www.nthState.com
//
//  See LICENSE for license information.
//

import Foundation

public struct Configuration: Decodable {
  public let warningsAsErrors: Bool
  public let duplicatesAsErrors: Bool
  public let accessToken: String
  public let enableAnalysis: Bool
  public let reportAnalysisResults: Bool
  public let generateSourceCode: Bool
  public let folderName: String?
  public let jsonURL: URL?
  public var projectDir: URL
  
  // MARK: - Constructor
  
  public init(warningsAsErrors: Bool = false,
              duplicatesAsErrors: Bool = false,
              accessToken: String = "",
              enableAnalysis: Bool = true,
              reportAnalysisResults: Bool = true,
              generateSourceCode: Bool = true,
              folderName: String? = nil,
              jsonURL: URL? = nil,
              projectDir: URL) {
    self.warningsAsErrors = warningsAsErrors
    self.duplicatesAsErrors = duplicatesAsErrors
    self.accessToken = accessToken
    self.enableAnalysis = enableAnalysis
    self.reportAnalysisResults = reportAnalysisResults
    self.generateSourceCode = generateSourceCode
    self.folderName = folderName
    self.jsonURL = jsonURL
    self.projectDir = projectDir
  }
  
  // MARK: - Decodable from PLIST
  
  enum CodingKeys: CodingKey {
    case warningsAsErrors
    case duplicatesAsErrors
    case accessToken
    case enableAnalysis
    case reportAnalysisResults
    case generateSourceCode
    case folderName
    case jsonURL
    case projectDir
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.warningsAsErrors = try container.decode(Bool.self, forKey: .warningsAsErrors)
    self.duplicatesAsErrors = try container.decode(Bool.self, forKey: .duplicatesAsErrors)
    self.accessToken = try container.decode(String.self, forKey: .accessToken)
    self.enableAnalysis = try container.decode(Bool.self, forKey: .enableAnalysis)
    self.reportAnalysisResults = try container.decode(Bool.self, forKey: .reportAnalysisResults)
    self.generateSourceCode = try container.decode(Bool.self, forKey: .generateSourceCode)
    self.folderName = try container.decodeIfPresent(String.self, forKey: .folderName)
    self.jsonURL = try container.decodeIfPresent(URL.self, forKey: .jsonURL)
    self.projectDir = URL(string: ProcessInfo.processInfo.environment["PROJECT_DIR"] ?? "")!
  }
}

extension Configuration: CustomStringConvertible {
  public var description: String {
    return """
      warningsAsErrors: \(warningsAsErrors)
      duplicatesAsErrors: \(duplicatesAsErrors)
      accessToken: \(accessToken)
      enableAnalysis: \(enableAnalysis)
      reportAnalysisResults: \(reportAnalysisResults)
      generateSourceCode: \(generateSourceCode)
      folderName: \(String(describing: folderName))
      jsonURL: \(String(describing: jsonURL))
      projectDir: \(String(describing: projectDir))
      """
  }
}
