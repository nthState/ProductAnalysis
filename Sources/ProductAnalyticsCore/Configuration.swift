//
//  File.swift
//  
//
//  Created by Chris Davis on 09/10/2022.
//

import Foundation

/**
 Configuration object
 */
public struct Configuration: Decodable {
  public let warningsAsErrors: Bool
  public let accessToken: String
  public let enableAnalysis: Bool
  public let reportAnalysisResults: Bool
  public let generateSourceCode: Bool
  public let outputFolder: URL?
  public let jsonURL: URL?
  internal let projectDir: URL?
  
  public init(warningsAsErrors: Bool = false, accessToken: String = "", enableAnalysis: Bool = true, reportAnalysisResults: Bool = true, generateSourceCode: Bool = true, outputFolder: URL? = nil, jsonURL: URL? = nil, projectDir: URL? = nil) {
    self.warningsAsErrors = warningsAsErrors
    self.accessToken = accessToken
    self.enableAnalysis = enableAnalysis
    self.reportAnalysisResults = reportAnalysisResults
    self.generateSourceCode = generateSourceCode
    self.outputFolder = outputFolder
    self.jsonURL = jsonURL
    self.projectDir = projectDir
  }
  
  // MARK: Decodable from PLIST
  
  enum CodingKeys: CodingKey {
    case warningsAsErrors
    case accessToken
    case enableAnalysis
    case reportAnalysisResults
    case generateSourceCode
    case outputFolder
    case jsonURL
    case projectDir
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.warningsAsErrors = try container.decode(Bool.self, forKey: .warningsAsErrors)
    self.accessToken = try container.decode(String.self, forKey: .accessToken)
    self.enableAnalysis = try container.decode(Bool.self, forKey: .enableAnalysis)
    self.reportAnalysisResults = try container.decode(Bool.self, forKey: .reportAnalysisResults)
    self.generateSourceCode = try container.decode(Bool.self, forKey: .generateSourceCode)
    self.outputFolder = try container.decodeIfPresent(URL.self, forKey: .outputFolder)
    self.jsonURL = try container.decodeIfPresent(URL.self, forKey: .jsonURL)
    self.projectDir = URL(string: ProcessInfo.processInfo.environment["PROJECT_DIR"] ?? "")
  }
}

extension Configuration: CustomStringConvertible {
  public var description: String {
    return """
      warningsAsErrors: \(warningsAsErrors)
      accessToken: \(accessToken)
      enableAnalysis: \(enableAnalysis)
      reportAnalysisResults: \(reportAnalysisResults)
      generateSourceCode: \(generateSourceCode)
      outputFolder: \(String(describing: outputFolder))
      jsonURL: \(String(describing: jsonURL))
      """
  }
}
