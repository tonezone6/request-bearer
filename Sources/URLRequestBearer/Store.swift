
import Foundation

extension URLRequest.Bearer {
    public struct Store {
        public let token: () -> JWT?
        public let save: (JWT) -> Void
        public let delete: () -> Void
        
        public init(
            token: @escaping () -> JWT?,
            save: @escaping(JWT) -> Void,
            delete: @escaping () -> Void
        ) {
            self.token = token
            self.save = save
            self.delete = delete
        }
    }
}
