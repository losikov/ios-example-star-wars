
import Foundation

let pageSize = 10

/// To hold and combine search results for multiple pages.
/// Initially allocates a list for all elements and set them with nils,
/// **addPageResults** used to substitute nils with the data from the page.
fileprivate class SearchResponsesHolder<Item: Decodable> {
    /// To store already lading pages, not to request the same page multipe times
    private var loadingPages: Set<Int> = []
    private var loadedPages: Set<Int> = []
    
    /// Holds all items, initialized with nil objects, updated with newly loaded pages
    private var items: [Item?] = []
    
    /// To keep track if the first page is loaded
    private var count: Int = -1
    
    /// Must be called when first page is loaded
    private func initDefaults(searchResponse: SearchItems<Item>) {
        self.items = [Item?].init(repeating: nil, count: searchResponse.count ?? 0)
        self.count = searchResponse.count ?? -1
    }
    
    /// Add results from a new loaded page
    /// - returns: list of indexes of the objects updated in the storage
    func addPageResults(searchResponse: SearchItems<Item>, page: Int) -> [Int]? {
        var initial = false
        if count != searchResponse.count {
            initial = true
            initDefaults(searchResponse: searchResponse)
        }
        
        var indexes = [Int]()
        
        let k = (page - 1) * pageSize
        for (i, ch) in (searchResponse.results ?? []).enumerated() {
            let index = k + i
            self.items[index] = ch
            indexes.append(index)
        }
        
        return initial ? nil : indexes
    }
    
    /// To covert to a data structure to pass to UI
    func searchResponse(for name: String, indexes: [Int]? = nil) -> SearchResponse<Item> {
        return SearchResponse<Item>(name: name, items: items, indexes: indexes)
    }
    
    /// Converts index to required page number
    class func page(for index: Int) -> Int {
        return index / pageSize + 1
    }
    
    /// Mark page as loaded if success
    func setAsLoaded(page: Int) {
        loadingPages.remove(page)
        loadedPages.insert(page)
    }
    
    /// Mark page as loading
    func setAsLoading(page: Int) {
        loadingPages.insert(page)
    }
    
    /// Reset loading state in case of error
    func resetLoading(page: Int) {
        loadingPages.remove(page)
    }
    
    /// Check if page is loaded
    func isLoaded(page: Int) -> Bool {
        return loadedPages.contains(page)
    }
    
    /// Check if page is loading
    func isLoading(page: Int) -> Bool {
        return loadingPages.contains(page)
    }
}

/// Generic Class to performa search requests for any SWApi Objects using pagination.
/// Inheritor Class must set Item Type (Character, Planet, etc) and override searchURL method.
class Search<Item: Decodable> {
    
    /// Holds all data [searchString: data]
    private let searchCache = NSCache<NSString, SearchResponsesHolder<Item>>()
    
    typealias SearchCompletionResult = (APIResponse<SearchResponse<Item>>) -> Void
    
    /// Universal search through any SWApi objects using overriden searchURL.
    /// Should be called every time when nil object is accessed to fetch the next page, and update the list.
    /// Safe to call multiple times with the same search string and index.
    /// - parameter name: search string
    /// - parameter index: index of element in the list which is unavailable to request an update of search results
    /// - parameter completionHandler: returns a list of SWApi Objects, current or updated.
    /// The list is always allocated with the complete results size, and with each next search,
    /// or with each next page, nil objects are replaced with real ones.
    final func search(for name: String,
                      index: Int,
                      completionHandler: @escaping SearchCompletionResult) {
        let page = SearchResponsesHolder<Item>.page(for: index)
        
        // check if page is already in cache or already loading
        var searchHolder = searchCache.object(forKey: NSString(string: name))
        if searchHolder != nil {
            if searchHolder!.isLoading(page: page) || searchHolder!.isLoaded(page: page) {
                completionHandler(APIResponse.data(searchHolder!.searchResponse(for: name)))
                return
            }
        } else {
            searchHolder = SearchResponsesHolder()
            searchCache.setObject(searchHolder!, forKey: NSString(string: name))
        }
        
        // make page as loading
        searchHolder!.setAsLoading(page: page)
        
        NetworkIndicator.shared.activate()
        
        // redefine to cleanup properly
        let completionHandler: SearchCompletionResult = { [weak searchHolder] result in
            DispatchQueue.main.async {
                NetworkIndicator.shared.deactivate()
                
                switch result {
                case .data(_):
                    searchHolder?.setAsLoaded(page: page)
                case .error(_):
                    searchHolder?.resetLoading(page: page)
                }
                
                completionHandler(result)
            }
        }
        
        // perform a request
        guard let searchURL = searchURL(for: name, page: page) else {
            completionHandler(APIResponse.error(APIError.invalidUrl))
            return
        }
        
        URLSession.shared.dataTask(with: searchURL) { [weak searchHolder] (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                completionHandler(APIResponse.error(error))
                return
            }
            
            guard
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200,
                let data = data
            else {
                completionHandler(APIResponse.error(APIError.invalidAPIResponse))
                return
            }
            
            do {
                let json = try JSONDecoder().decode(SearchItems<Item>.self, from: data)
                //print(try JSONSerialization.jsonObject(with: data, options: []))
                DispatchQueue.main.async {
                    let indexes = searchHolder?.addPageResults(searchResponse: json, page: page)
                    if searchHolder != nil {
                        let searchResponse = searchHolder!.searchResponse(for: name, indexes: indexes)
                        completionHandler(APIResponse.data(searchResponse))
                    }
                }
            } catch let error as NSError {
                print("Failed to parse response: '\(error)'")
                completionHandler(APIResponse.error(error))
                return
            }
        }.resume()
    }
    
    /// Must be overriden to return search url
    func searchURL(for name: String, page: Int) -> URL? {
        fatalError("must override with URL")
    }
    
}
