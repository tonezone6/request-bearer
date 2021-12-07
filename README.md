# URLRequest Bearer

A simple extension tool for adding authorization tokens to `URLRequests`.

```swift
Just(URLRequest.user)
    .flatMap(URLRequest.Bearer(store: .keychain, handler: .live).authorize)
    .flatMap(URLSession.shared.dataTaskPublisher)
    .map(\.data)
    .decode(type: User.self, decoder: JSONDecoder())
    .receive(on: DispatchQueue.main)
    .catch { error in /*...*/ }
    .assign(to: &$user)
```

`Bearer.Store` has 3 closure requirements: `token`, `saveToken` and `deleteToken`.

```swift
extension URLRequest.Bearer.Store {
    static var keychain: Self {
        let keychain = Keychain()
        let key = "app.jwt.token"
        return .init(
            token: { /* get token */ },
            save: { /* save token */ },
            delete: { /* clear keychain */ }
        )
    }
}

```

`Bearer.Handler` has two closure requirements: `expired` and `refresh`.

```swift 
extension URLRequest.Bearer.Handler {
    static var live: Self {
        .init(
            expired: { /* check token if expired */ },
            refresh: { /* refresh token */ }
        )
    }    
}
```
