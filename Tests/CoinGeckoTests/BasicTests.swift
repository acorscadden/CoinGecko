import XCTest
@testable import CoinGecko

final class BasicTests: XCTestCase {
    
    private let client = CoinGeckoClient()
    
    func testPing() {
        let exp = XCTestExpectation()
        let ping = Resources.ping { (result: Result<Pong, CoinGeckoError>) in
            guard case .success(let pong) = result else { XCTFail(); exp.fulfill(); return }
            XCTAssertTrue(pong.gecko_says == "(V3) To the Moon!")
            exp.fulfill()
        }
        client.load(ping)
        wait(for: [exp], timeout: 10.0)
    }
    
    func testSupported() {
        let exp = XCTestExpectation()
        let supported = Resources.supported { (result: Result<SupportedList, CoinGeckoError>) in
            guard case .success(let supported) = result else { XCTFail(); exp.fulfill(); return }
            XCTAssertTrue(supported.count > 0)
            XCTAssertTrue(supported.contains(where: { $0 == "cad" }))
            exp.fulfill()
        }
        client.load(supported)
        wait(for: [exp], timeout: 10.0)
    }
    
}
