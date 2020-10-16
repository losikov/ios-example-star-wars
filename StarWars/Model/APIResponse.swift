
import Foundation

/// Base structure for all API functions to return a result in a handler
enum APIResponse<DataType> {
    case data(DataType)
    case error(Error)
}
