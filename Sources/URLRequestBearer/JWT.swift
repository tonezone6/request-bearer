
import Foundation

extension URLRequest.Bearer {
    public struct JWT: Codable {
        public let value: String
        public let refresh: String
        
        public init(value: String, refresh: String) {
            self.value = value
            self.refresh = refresh
        }
    }
    
    public typealias Token = JWT
}
