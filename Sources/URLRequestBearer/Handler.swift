
import Combine
import Foundation

extension URLRequest.Bearer {
    public struct Handler {
        public let expired: (Token) -> Bool
        public let refresh: (Token) -> AnyPublisher<Token, URLError>
        
        public init(
            expired: @escaping (Token) -> Bool,
            refresh: @escaping (Token) -> AnyPublisher<Token, URLError>
        ) {
            self.expired = expired
            self.refresh = refresh
        }
    }
}
