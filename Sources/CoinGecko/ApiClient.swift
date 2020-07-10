//
//  ApiClient.swift
//  
//
//  Created by Adrian Corscadden on 2020-07-03.
//

import Foundation

typealias Callback<T> = (Result<T, CoinGeckoError>) -> Void

struct Resource<T: Codable> {
    
    let endpoint: Endpoint
    let method: Method
    let pathParam: String?
    let params: [URLQueryItem]?
    let parse: ((Data) -> T)? //optional parse function if Data isn't directly decodable to T
    let completion: (Result<T, CoinGeckoError>) -> Void //called on main thread
    
    init(_ endpoint: Endpoint,
         method: Method,
         pathParam: String? = nil,
         params: [URLQueryItem]? = nil,
         parse: ((Data) -> T)? = nil,
         completion: @escaping (Result<T, CoinGeckoError>) -> Void) {
        self.endpoint = endpoint
        self.method = method
        self.pathParam = pathParam
        self.params = params
        self.parse = parse
        self.completion = completion
    }
}

enum Method: String {
    case GET
}

enum CoinGeckoError: Error {
    case general
}

class ApiClient {
    
    private let baseURL = "https://api.coingecko.com/api/v3"
    
    func load<T: Codable>(_ resource: Resource<T>) {
        let completion = resource.completion
        var path = resource.endpoint.rawValue
        path = resource.pathParam == nil ? path : String(format: path, resource.pathParam!)
        var url = URL(string: "\(baseURL)\(path)")!
        if let params = resource.params {
            var comps = URLComponents(url: url, resolvingAgainstBaseURL: true)!
            comps.queryItems = comps.queryItems ?? []
            comps.queryItems!.append(contentsOf: params)
            url = comps.url!
        }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { completion(.failure(.general)); return }
            print(String(data: data, encoding: .utf8)!)
            do {
                var result: T
                if let parse = resource.parse {
                    result = parse(data)
                } else {
                   result = try JSONDecoder().decode(T.self, from: data)
                }
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            } catch _ {
                DispatchQueue.main.async {
                    completion(.failure(.general))
                }
            }
        }.resume()
    }
}
