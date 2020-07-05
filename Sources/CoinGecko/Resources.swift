//
//  Resources.swift
//  
//
//  Created by Adrian Corscadden on 2020-07-05.
//

import Foundation

enum Resources {
    
    // MARK: - Ping
    static func ping<Pong>(_ callback: @escaping Callback<Pong>) -> Resource<Pong> {
        return Resource(.ping, method: .GET, completion: callback)
    }
    
    // MARK: - Simple
    static func simplePrice<PriceList>(ids: [String], vsCurrency: String, options: [SimplePriceOptions], _ callback: @escaping Callback<PriceList>) -> Resource<PriceList> {
        let params = SimplePriceParams(ids: ids,
                                       vsCurrency: vsCurrency,
                                       includeMarketCap: options.contains(.marketCap),
                                       include24hrVol: options.contains(.vol),
                                       include24hrChange: options.contains(.change),
                                       includeLastUpdatedAt: options.contains(.lastUpdated))
        let parse: (Data) -> PriceList = { data in
            var result = [SimplePrice]()
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                params.ids.forEach { id in
                    guard let item = json?[id] as? [String: Any] else { print("item not found"); return }
                    if let price = SimplePrice(json: item, id: id, prefix: vsCurrency) {
                        result.append(price)
                    }
                }
            } catch let e {
                print("json error: \(e)")
            }
            return result as! PriceList
        }
        return Resource(.simplePrice, method: .GET, params: params.queryItems(), parse: parse, completion: callback)
    }
    
    static func supported<SupportedList>(_ callback: @escaping Callback<SupportedList>) -> Resource<SupportedList> {
        return Resource(.supportedVs, method: .GET, completion: callback)
    }
    
    // MARK: - Coins
    
    static func coins<CoinList>(_ callback: @escaping Callback<CoinList>) -> Resource<CoinList> {
        return Resource(.coinsList, method: .GET, completion: callback)
    }

}
