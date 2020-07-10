//
//  MarketChart.swift
//  
//
//  Created by Adrian Corscadden on 2020-07-09.
//

import Foundation

public struct MarketChart: Codable {
    public let prices: [[Double]]
}

extension MarketChart {
    public var dataPoints: [PriceDataPoint] {
        prices.compactMap {
            guard $0.count == 2 else { return nil }
            return PriceDataPoint(timestamp: Int($0[0]), price: $0[1])
        }
    }
}

public struct PriceDataPoint: Codable {
    public let timestamp: Int
    public let price: Double
}
