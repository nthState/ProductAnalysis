import XCTest
@testable import ProductAnalyticsCore

final class ProductAnalyticsCoreTests: XCTestCase {
  
  func testDecode() async throws {
    
    let bundle = Bundle.module
    let url = bundle.url(forResource: "ExampleProductKeys", withExtension: "json")!
    
    let calculate = Calculate()
    let result = try await calculate.fetchAnalytics(url: url)
    
    
  }
  
  func testDecode2() async throws {
    
    let url = URL(string: "https://raw.githubusercontent.com/nthState/ProductAnalytics/main/Tests/ProductAnalyticsCoreTests/Resources/ExampleProductKeys.json")!
    
    let calculate = Calculate()
    let result = try await calculate.fetchAnalytics(url: url)
    
    
  }
}
