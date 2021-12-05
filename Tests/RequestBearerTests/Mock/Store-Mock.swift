
import Foundation
import RequestBearer

extension Store where Self == StoreMock {
    static var mock: Self {
        .init()
    }
}

class StoreMock: Store {
    private var dict = [String : Data]()

    var key: String {
        "request.bearer.token"
    }

    var token: Token? {
        guard let data = dict[key],
              let token = try? JSONDecoder().decode(Token.self, from: data)
        else { return nil }
        return token
    }

    func save(token: Token?) {
        if let value = token,
           let data = try? JSONEncoder().encode(value) {
            dict.updateValue(data, forKey: key)
        } else {
            dict.removeValue(forKey: key)
        }
    }

    func delete() {
        dict.removeValue(forKey: key)
    }
}
