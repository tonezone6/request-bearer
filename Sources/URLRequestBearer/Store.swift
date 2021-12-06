
import Foundation

extension URLRequest.Bearer {
    public struct Store {
        public let token: () -> Token?
        public let saveToken: (Token) -> Void
        public let delete: () -> Void
        
        public init(
            token: @escaping () -> Token?,
            saveToken: @escaping(Token) -> Void,
            delete: @escaping () -> Void
        ) {
            self.token = token
            self.saveToken = saveToken
            self.delete = delete
        }
    }
}
