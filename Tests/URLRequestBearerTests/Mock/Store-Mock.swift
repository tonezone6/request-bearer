
import Foundation
import URLRequestBearer

struct Token: JWT, Codable {
    let value: String
    let refresh: String
}

extension URLRequest.Bearer.Store {
    static var mock: Self {
        var dict = [String : Data]()
        let key = "jwt.token.mock"
        
        let decoder = JSONDecoder()
        let encoder = JSONEncoder()
        
        return .init(
            token: {
                guard let data = dict[key],
                      let value = try? decoder.decode(Token.self, from: data)
                else { return nil }
                return value
            },
            save: { token in
                if let token = token as? Token,
                   let data = try? encoder.encode(token) {
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
