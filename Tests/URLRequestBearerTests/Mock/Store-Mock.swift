
import Foundation
import URLRequestBearer

extension URLRequest.Bearer.Store {
    static var mock: Self {
        var dict = [String : Data]()
        let key = "jwt.token.mock"
        let decoder = JSONDecoder()
        
        return .init(
            token: {
                guard let data = dict[key],
                      let value = try? decoder.decode(URLRequest.Bearer.Token.self, from: data)
                else { return nil }
                return value
            },
            saveToken: { token in
                if let data = try? JSONEncoder().encode(token) {
                    dict.updateValue(data, forKey: key)
                } else {
                    dict.removeValue(forKey: key)
                }
            },
            delete: {
                dict.removeValue(forKey: key)
            }
        )
    }
}
