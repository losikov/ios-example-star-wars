
import Foundation

/// Data structure returned to UI
struct SearchResponse<Item: Decodable> {
    /// Search name
    let name: String
    
    /// List of objets (for loaded pages) or nils (for not loaded pages).
    /// Initiallly initialized with nils, and updated with objects as pages are loaded.
    let items: [Item?]
    
    /// List of indexes of updated items
    let indexes: [Int]?
    
}
