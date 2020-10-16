
import Foundation

/// SIngleton Class to Load any SWApi Object and store in cache
class ObjectLoader {
    
    /// Instance Accessor
    static let shared = ObjectLoader()
    
    private init() {
    }
    
    /// Holds all data [url: object]
    private let objectsCache = NSCache<NSString, Object>()
    
    /// To prevent multiiple requests to get the same object
    private var loadingObjects = Set<String>()
    
    typealias LoadCompletionResult = (APIResponse<Object>) -> Void
    
    /// Load SWApi Object by url and stores it in cache
    /// - parameter url: object to load
    /// - parameter completionHandler: error or object, called only if there was a real network request,
    ///   otherwise not called
    /// - returns: if object is already in cache, returns a real object, otherwise nil
    final func load(for url: String,
                    completionHandler: @escaping LoadCompletionResult) -> Object? {
        // if object is in cache, just return it
        let object = objectsCache.object(forKey: NSString(string: url))
        if object != nil {
            return object
        }
        
        // if object is beeing requested, interrupt current request
        if loadingObjects.contains(url) {
            return nil
        }
        
        guard let requestUrl = URL(string: url) else {
            completionHandler(APIResponse.error(APIError.invalidUrl))
            return nil
        }
        
        // add object to a loading list
        loadingObjects.insert(url)
        
        NetworkIndicator.shared.activate()
        
        // redefine to cleanup properly
        let completionHandler: LoadCompletionResult = { [weak self] result in
            DispatchQueue.main.async {
                NetworkIndicator.shared.deactivate()
                
                self?.loadingObjects.remove(url)
                completionHandler(result)
            }
        }
        
        // perform a request
        URLSession.shared.dataTask(with: requestUrl) { [weak self] (data, response, error) in
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
                let object = try Object.decodeToObjectWith(url: url, from: data)
                //print(try JSONSerialization.jsonObject(with: data, options: []))
                DispatchQueue.main.async {
                    self?.objectsCache.setObject(object, forKey: NSString(string: url))
                    completionHandler(APIResponse.data(object))
                }
            } catch let error as NSError {
                print("Failed to parse response: '\(error)'")
                completionHandler(APIResponse.error(error))
                return
            }
        }.resume()
        
        return nil
    }
    
}
