import XCTest
@testable import CoinGecko

final class SimpleTests: XCTestCase {

    private let client = ApiClient()

    func testIncludeAll() {
        let exp = XCTestExpectation()
        let ids = ["bitcoin"]
        let vsCurrency = "cad"
        let price = Resources.simplePrice(ids: ids, vsCurrency: vsCurrency, options: SimplePriceOptions.allCases) { (result: Result<PriceList, CoinGeckoError>) in
            guard case .success(let prices) = result else { XCTFail(); exp.fulfill(); return }
            guard let first = prices.first else { XCTFail("Prices should not be empty"); exp.fulfill(); return }
            
            XCTAssert(first.id == "bitcoin", "")
            XCTAssert(first.change24hr != nil, "Change 24hr should not be nil")
            XCTAssert(first.lastUpdatedAt != nil, "Last Updated At should not be nil")
            XCTAssert(first.marketCap != nil, "Market Cap should not be nil")
            XCTAssert(first.vol24hr != nil, "Vol should not be nil")
            
            exp.fulfill()
        }
        client.load(price)
        wait(for: [exp], timeout: 10.0)
    }
    
    func testIncludeNone() {
        let exp = XCTestExpectation()
        let ids = ["bitcoin"]
        let vsCurrency = "cad"
        let price = Resources.simplePrice(ids: ids, vsCurrency: vsCurrency, options: []) { (result: Result<PriceList, CoinGeckoError>) in
            guard case .success(let prices) = result else { XCTFail(); exp.fulfill(); return }
            guard let first = prices.first else { XCTFail("Prices should not be empty"); exp.fulfill(); return }
            
            XCTAssert(first.change24hr == nil, "Change 24hr should be nil")
            XCTAssert(first.lastUpdatedAt == nil, "Last Updated At should be nil")
            XCTAssert(first.marketCap == nil, "Market Cap should be nil")
            XCTAssert(first.vol24hr == nil, "Vol should be nil")
            
            exp.fulfill()
        }
        client.load(price)
        wait(for: [exp], timeout: 10.0)
    }

}
