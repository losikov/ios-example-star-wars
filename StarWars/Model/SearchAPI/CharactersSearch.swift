
import Foundation

/// Characters Search
class CharactersSearch: Search<Character> {

    override func searchURL(for name: String, page: Int) -> URL? {
        guard let escapedName = name.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) else { return nil }
        
        let url = "\(serverUrl)/api/people/?search=\(escapedName)&page=\(page)"
        return URL(string: url)
    }
    
}
