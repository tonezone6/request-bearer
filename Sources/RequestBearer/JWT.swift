
import Combine
import Foundation

public protocol JWT {
    var value: String { get }
    var refresh: String { get }
}

public struct Token: JWT, Codable {
    public let value: String
    public let refresh: String
    
    public init(value: String, refresh: String) {
        self.value = value
        self.refresh = refresh
    }
}

public protocol Store {
    var key: String { get }
    var token: Token? { get }
    
    func save(token: Token?)
    func delete()
}

public struct Handler {
    var expired: (Token) -> Bool
    var refresh: (Token) -> AnyPublisher<Token, URLError>
    
    public init(
        expired: @escaping (Token) -> Bool,
        refresh: @escaping (Token) -> AnyPublisher<Token, URLError>
    ) {
        self.expired = expired
        self.refresh = refresh
    }
}
