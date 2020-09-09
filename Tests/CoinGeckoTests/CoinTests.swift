//
//  CoinTests.swift
//  
//
//  Created by Adrian Corscadden on 2020-07-09.
//

import XCTest
@testable import CoinGecko

final class CoinTests: XCTestCase {

    private let client = CoinGeckoClient()
    
    func testListCoins() {
        let exp = XCTestExpectation()
        let coins = Resources.coins { (result: Result<CoinList, CoinGeckoError>) in
            guard case .success(let supported) = result else { XCTFail(); exp.fulfill(); return }
            XCTAssertTrue(supported.count > 0)
            XCTAssertTrue(supported.contains(where: { $0.symbol == "btc" }))
            exp.fulfill()
        }
        client.load(coins)
        wait(for: [exp], timeout: 10.0)
    }
    
    func testMarketCharts() {
        let exp = XCTestExpectation()
        let chart = Resources.marketChart(currencyId: "bitcoin", vs: "cad", days: 30) { (result: Result<MarketChart, CoinGeckoError>) in
            guard case .success(let data) = result else { XCTFail(); exp.fulfill(); return }
            XCTAssert(data.prices.count > 0, "Prices shouldn't be empty")
            exp.fulfill()
        }
        client.load(chart)
        wait(for: [exp], timeout: 10.0)
    }
    
    func testMarketData() {
        let exp = XCTestExpectation()
        let marketData = Resources.coin(currencyId: "bitcoin", vs: "cad") { (result: Result<MarketContainer, CoinGeckoError>) in
            guard case .success(let data) = result else { XCTFail(); exp.fulfill(); return }
            XCTAssert(data.marketCap > 0)
            XCTAssert(data.high24h > 0)
            XCTAssert(data.low24h > 0)
            XCTAssert(data.totalVolume > 0)
            exp.fulfill()
        }
        client.load(marketData)
        wait(for: [exp], timeout: 10.0)
    }
}
