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

The handler has two closure requirements, `expired` and `refresh`.

```swift 
extension URLRequest.Bearer.Handler {
    static var live: Self {
        .init(
            expired: { token in 
                // check if token is expired
                // ...
            },
            refresh: { token in
                // refresh the token
                // ...
            }
        )
    }    
}
```
