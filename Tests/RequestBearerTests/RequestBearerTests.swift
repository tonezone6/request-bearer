
import Combine
import RequestBearer
import XCTest

class RequestBearerTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    
    func testTokenValid() {
        let store: URLRequest.Bearer.Store = .mock
        let bearer = URLRequest.Bearer(
            store: store,
            handler: .init(
                expired: { _ in false },
                refresh: { _ in
                    fatalError("should not be called if token not expired")
                }
            )
        )
        
        let request = PassthroughSubject<URLRequest, Never>()
        var headers: [String?] = []
        
        request
            .setFailureType(to: URLError.self)
            .flatMap(bearer.authorize)
            .map { $0.value(forHTTPHeaderField: "Authorization") }
            .assertNoFailure()
            .sink { headers.append($0) }
            .store(in: &cancellables)

        XCTAssertNil(store.token())

        request.send(.mock)
                
        XCTAssertEqual(headers, [nil])
        
        store.saveToken(.init(value: "xyz", refresh: ""))
        request.send(.mock)
        
        XCTAssertEqual(headers, [nil, "Bearer xyz"])
        XCTAssertEqual(store.token()?.value, "xyz")
    }
    
    func testTokenExpired() {
        let store: URLRequest.Bearer.Store = .mock
        let bearer = URLRequest.Bearer(
            store: store,
            handler: .init(
                expired: { _ in true },
                refresh: { _ in
                    Just(.init(value: "new.xyz", refresh: ""))
                        .setFailureType(to: URLError.self)
                        .eraseToAnyPublisher()
                }
            )
        )

        let request = PassthroughSubject<URLRequest, Never>()
        var headers: [String?] = []
        
        request
            .setFailureType(to: URLError.self)
            .flatMap(bearer.authorize)
            .map { $0.value(forHTTPHeaderField: "Authorization") }
            .assertNoFailure()
            .sink { headers.append($0) }
            .store(in: &cancellables)

        store.saveToken(.init(value: "xyz", refresh: ""))

        XCTAssertEqual(store.token()?.value, "xyz")
    
        request.send(.mock)
        
        XCTAssertEqual(headers, ["Bearer new.xyz"])
        XCTAssertEqual(store.token()?.value, "new.xyz") 
        
        store.delete()
        request.send(.mock)
        
        XCTAssertEqual(headers, ["Bearer new.xyz", nil])
        XCTAssertNil(store.token())
    }
}
