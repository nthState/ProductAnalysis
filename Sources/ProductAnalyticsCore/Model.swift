//
//  File.swift
//  
//
//  Created by Chris Davis on 10/10/2022.
//

import Foundation

public struct Analytics: Decodable {
  
  let categories: [String: [String: SubCategory]]
  
  // MARK: Decodable
  
  enum CodingKeys: CodingKey {
    case productAnalysis
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.categories = try container.decode([String: [String: SubCategory]].self, forKey: .productAnalysis)
  }
}

//public struct Category: Decodable {
//
//  let subCategories: [String: SubCategory]
//
//  // MARK: Decodable
//
//  enum CodingKeys: CodingKey {
//   // case productAnalysis
//  }
//
//  public init(from decoder: Decoder) throws {
//    let container = try decoder.container(keyedBy: CodingKeys.self)
//
//    let container = try decoder.
//
//    self.categories = try container.decode([String: SubCategory].self, forKey: .productAnalysis)
//  }
//
//}


public struct SubCategory: Decodable {
  let children: [Child]
  
  enum CodingKeys: CodingKey {
    case children
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.children = try container.decode([Child].self, forKey: .children)
  }
}


public struct Child: Decodable {
  let name: String
  let value: String
}
