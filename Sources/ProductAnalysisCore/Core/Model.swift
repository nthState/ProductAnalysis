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

public struct Analytics: Decodable {
  
  let categories: [String: [String: SubCategory]]
  
  // MARK: - Constructor
  
  public init(categories: [String: [String: SubCategory]]) {
    self.categories = categories
  }
  
  // MARK: - Decodable
  
  enum CodingKeys: CodingKey {
    case productAnalysis
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.categories = try container.decode([String: [String: SubCategory]].self, forKey: .productAnalysis)
  }
}

public struct SubCategory: Decodable {
  let children: [Child]
  
  // MARK: - Constructor
  
  public init(children: [Child]) {
    self.children = children
  }
  
  // MARK: - Decodable
  
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
