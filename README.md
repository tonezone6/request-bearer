# URLRequest Bearer

A simple tool to add authorization bearer tokens to `URLRequest`s.
Just define a `store` and a `handler` then authorize the request:

```swift
Just(URLRequest.userDetails)
    .flatMap(URLRequest.Bearer(store: .keychain, handler: .live).authorize)
    .flatMap(URLSession.shared.dataTaskPublisher)
    .map(\.data)
    .decode(type: User.self, decoder: JSONDecoder())
    .receive(on: DispatchQueue.main)
    .catch { error in /*...*/ }
    .assign(to: &$user)
```

The store has 3 closure requirements, `token`, `saveToken` and `deleteToken`:

```swift
extension URLRequest.Bearer.Store {
    static var keychain: Self {
        let keychain = Keychain()
        let key = "myapp.jwt.token"
        
        return .init(
            token: {
                guard let data = keychain.data(for: key),
                      let value = try? JSONDecoder().decode(Token.self, from: data)
                else { return nil }
                return value
            },
            saveToken: { token in
                if let token = token, let data = try? JSONEncoder().encode(token) {
                    keychain.set(data, forKey: key)
                } else {
                    keychain.set(nil, forKey: key)
                }
            },
            deleteToken: {
                keychain.clear()
            }
        )
    }
}

```

The handler has two closure requirements, `expired` and `refresh`.

```swift 
extension URLRequest.Bearer.Handler {
    static var live: Self {
        .init(
            expired: { token in
                decode(jwt: token.value).expired
            },
            refresh: { token in
                let request = URLRequest(
                    endpoint: "endpoint/refresh",
                    queryItems: [.init(name: "refresh_token", value: token.refresh)]
                )
                return URLSession.shared
                    .dataTaskPublisher(for: request)
                    .map(\.data)
                    .decode(type: Token.self, decoder: JSONDecoder())
                    .eraseToAnyPublisher()
            }
        )
    }    
}
```
