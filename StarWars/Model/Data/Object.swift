
import Foundation

/// Base Class for all SWApi objects
/// name or title access by name
class Object: Decodable {
    
    let name: String?
    let url : String?
    
    private enum CodingKeys: String, CodingKey {
        case name
        case title
        case url
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        // name initialized from name, or from title for Film
        var objectName = try? values.decode(String.self, forKey: .name)
        if objectName == nil {
            objectName = try values.decode(String.self, forKey: .title)
        }
        name = objectName
        
        url = try? values.decode(String.self, forKey: .url)
    }
    
    /// Factory method to decode an Object of required type: Character, Vehicle, etc, based on url value
    /// - parameter url: url which include object type: "people", "vehicle", etc
    /// - parameter data: raw data from server response
    /// - throws: decode errors
    /// - returns: object or matching type: Character, Vehicle, ..., Object
    class func decodeToObjectWith(url: String, from data: Data) throws -> Object {
        if url.contains("people") {
            return try JSONDecoder().decode(Character.self, from: data)
        }
        
        return try JSONDecoder().decode(Object.self, from: data)
    }

}
