//
//  File.swift
//  
//
//  Created by Chris Davis on 08/10/2022.
//

import Foundation

enum ProductAnalyticsError: Error {
  case invalidURL
}

public class Test {
  
  public init() {
    
  }
  
  public func doIt() {
    print("in foo")
  }
  
  public func fetch() async throws -> Analytics {
    
    guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1") else {
      throw ProductAnalyticsError.invalidURL
    }
    
    let (data, _) = try await URLSession.shared.data(from: url)
    let result = try JSONDecoder().decode(Analytics.self, from: data)
    return result
  }
  
  public func run(with configuration: ProductAnalyticsConfiguration) {
    print("Run with configuration")
    print(configuration)
  }
  
}

public class Analytics: Codable {
  let a: String
}
