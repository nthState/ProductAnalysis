import XCTest
@testable import ProductAnalyticsCore

final class ProductAnalyticsCoreTests: XCTestCase {
  
  func testDecode() async throws {
    
    let bundle = Bundle.module
    let url = bundle.url(forResource: "ExampleProductKeys", withExtension: "json")!
    
    let calculate = Calculate()
    do {
      _ = try await calculate.fetchAnalytics(url: url)
    } catch let error {
      XCTFail("Decode should have passed: \(error.localizedDescription)")
    }
    
  }

}
