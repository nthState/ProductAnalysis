import XCTest
@testable import ProductAnalyticsCore

final class ProductAnalyticsCoreTests: XCTestCase {
  
  func testDecode() async throws {
    
    let bundle = Bundle.module
    let url = bundle.url(forResource: "ExampleProductKeys", withExtension: "json")!
    
    let calculate = Calculate()
    let result = try await calculate.fetchAnalytics(url: url)
    
    
  }
}
