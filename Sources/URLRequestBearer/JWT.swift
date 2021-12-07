
import Foundation

public protocol JWT: Codable {
    var value: String { get }
    var refresh: String { get }
}
