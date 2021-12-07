
import Combine
import Foundation

extension URLRequest.Bearer {
    public struct Handler {
        public let expired: (JWT) -> Bool
        public let refresh: (JWT) -> AnyPublisher<JWT, URLError>
        
        public init(
            expired: @escaping (JWT) -> Bool,
            refresh: @escaping (JWT) -> AnyPublisher<JWT, URLError>
        ) {
            self.expired = expired
            self.refresh = refresh
        }
    }
}
