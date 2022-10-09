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
public struct ProductAnalyticsConfiguration: Decodable {
  public let warningsAsErrors: Bool
  public let accessToken: String
  public let enableLogging: Bool
  
  public init(warningsAsErrors: Bool, accessToken: String, enableLogging: Bool) {
    self.warningsAsErrors = warningsAsErrors
    self.accessToken = accessToken
    self.enableLogging = enableLogging
  }
  
  // MARK: Decodable
  
  enum CodingKeys: CodingKey {
    case warningsAsErrors
    case accessToken
    case enableLogging
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.warningsAsErrors = try container.decode(Bool.self, forKey: .warningsAsErrors)
    self.accessToken = try container.decode(String.self, forKey: .accessToken)
    self.enableLogging = try container.decode(Bool.self, forKey: .enableLogging)
  }
}

extension ProductAnalyticsConfiguration: CustomStringConvertible {
  public var description: String {
    "Config: warningsAsErrors: \(warningsAsErrors), accessToken: \(accessToken), enableLogging: \(enableLogging)"
  }
}
