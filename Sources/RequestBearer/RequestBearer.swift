
import Combine
import Foundation

public struct RequestBearer {
    private let store: Store
    private let handler: Handler
    
    public init(store: Store, handler: Handler) {
        self.store = store
        self.handler = handler
    }

    public func authorize(_ request: URLRequest) -> AnyPublisher<URLRequest, URLError> {
        guard let stored = store.token else {
            return Just(request)
                .setFailureType(to: URLError.self)
                .eraseToAnyPublisher()
        }
        
        return Just(stored)
            .setFailureType(to: URLError.self)
            .map(handler.expired)
            .flatMap { expired in
                expired ?
                    handler.refresh(stored)
                        .handleEvents(receiveOutput: store.save)
                        .eraseToAnyPublisher() :
                    Just(stored)
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
