
import Combine
import Foundation

extension URLRequest {
    public struct Bearer {
        let store: Store
        let handler: Handler
        
        public init(store: Store, handler: Handler) {
            self.store = store
            self.handler = handler
        }

        public func authorize(_ request: URLRequest) -> AnyPublisher<URLRequest, URLError> {
            guard let token = store.token() else {
                return Just(request)
                    .setFailureType(to: URLError.self)
                    .eraseToAnyPublisher()
            }
            
            return Just(token)
                .setFailureType(to: URLError.self)
                .map(handler.expired)
                .flatMap { expired in
                    expired ?
                        handler.refresh(token)
                            .handleEvents(receiveOutput: store.save)
                            .eraseToAnyPublisher() :
                        Just(token)
                            .setFailureType(to: URLError.self)
                            .eraseToAnyPublisher()
                }
                .map {
                    var auth = request
                    auth.addValue("Bearer \($0.value)", forHTTPHeaderField: "Authorization")
                    return auth
                }
                .eraseToAnyPublisher()
        }
    }
}
