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
  public let outputFolder: String?
  
  public init(warningsAsErrors: Bool, accessToken: String, enableAnalysis: Bool, reportAnalysisResults: Bool, generateSourceCode: Bool, outputFolder: String?) {
    self.warningsAsErrors = warningsAsErrors
    self.accessToken = accessToken
    self.enableAnalysis = enableAnalysis
    self.reportAnalysisResults = reportAnalysisResults
    self.generateSourceCode = generateSourceCode
    self.outputFolder = outputFolder
  }
  
  // MARK: Decodable
  
  enum CodingKeys: CodingKey {
    case warningsAsErrors
    case accessToken
    case enableAnalysis
    case reportAnalysisResults
    case generateSourceCode
    case outputFolder
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.warningsAsErrors = try container.decode(Bool.self, forKey: .warningsAsErrors)
    self.accessToken = try container.decode(String.self, forKey: .accessToken)
    self.enableAnalysis = try container.decode(Bool.self, forKey: .enableAnalysis)
    self.reportAnalysisResults = try container.decode(Bool.self, forKey: .reportAnalysisResults)
    self.generateSourceCode = try container.decode(Bool.self, forKey: .generateSourceCode)
    self.outputFolder = try container.decode(String?.self, forKey: .outputFolder)
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
      outputFolder: \(outputFolder ?? "none_set")
      """
  }
}
