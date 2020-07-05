//
//  Models.swift
//  
//
//  Created by Adrian Corscadden on 2020-07-03.
//

import Foundation

typealias SupportedList = [String]
typealias CoinList = [Coin]

struct Pong: Codable {
    let gecko_says: String
}

struct Coin: Codable {
    let id: String
    let symbol: String
    let name: String
}
