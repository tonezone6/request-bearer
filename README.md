# RequestBearer

A simple tool for mutating `URLRequest` with an authorization bearer if a JWT token is available.
To use it just define a `store` and a `handler` then chain the `authorize(_ request:)` like this:

```swift
Just(URLRequest.userDetails)
    .flatMap { RequestBearer(store: .keychain, handler: .live).authorize($0) }
    .flatMap(URLSession.shared.dataTaskPublisher)
    .map(\.data)
    .decode(type: User.self, decoder: JSONDecoder())
    .receive(on: DispatchQueue.main)
    .catch { error in /*...*/ }
    .assign(to: &$user)
```

The handler has two closures requirements, `expired` and `refresh`.

```swift 
extension RequestBearer.Handler {
    static var live: Self {
        .init(
            expired: { token in 
                // check if token is expired
                // ...
            },
            refresh: { token in
                // perform an api call to refresh the token
                // ...
            }
            
        )
    }    
}
```
