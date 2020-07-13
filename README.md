[![](https://static.coingecko.com/s/coingecko-logo-d13d6bcceddbb003f146b33c2f7e8193d72b93bb343d38e392897c3df3e78bdd.png)](https://coingecko.com)

## CoinGecko Swift

Swift wrapper for the [CoinGecko API](https://www.coingecko.com/en/api).

## Usage
```swift
let client = CoinGeckoClient()
let ping = Resources.ping { (result: Result<Pong, CoinGeckoError>) in
    guard case .success(let pong) = result else { return }
    print(pong.gecko_says) //(V3) To the Moon!
}
client.load(ping)
```
