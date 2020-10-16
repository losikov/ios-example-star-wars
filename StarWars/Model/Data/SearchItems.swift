
import Foundation

struct SearchItems<Item: Decodable> {
    
    var results: [Item]?
    var count: Int?
    
}

extension SearchItems: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case results
        case count
    }
    
}
