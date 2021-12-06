
import Foundation

extension URLRequest {
    static var mock: URLRequest {
        let url = URL(string: "https://mock")!
        return URLRequest(url: url)
    }
}
