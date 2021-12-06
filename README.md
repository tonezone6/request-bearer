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
            token: { /* get token */ },
            saveToken: { /* save token */ },
            deleteToken: { /* clear keychain */ }
        )
    }
}

```

The handler has two closure requirements, `expired` and `refresh`.

```swift 
extension URLRequest.Bearer.Handler {
    static var live: Self {
        .init(
            expired: { /* check if token expired */ },
            refresh: { /* refresh token */ }
        )
    }    
}
```
