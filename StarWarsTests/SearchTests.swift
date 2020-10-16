
import XCTest

class SearchTests: XCTestCase {
    
    private let charactersSearch = CharactersSearch()
    
    private func search(_ name: String, expectedCount: Int) -> Void {
        let expectation = self.expectation(description: "Success response")
        
        charactersSearch.search(for: name, index: 0) {response in
            XCTAssertTrue(Thread.isMainThread, "should call on main thread")
            
            switch response {
            case .error(let error):
                XCTFail(error.localizedDescription)
            case .data(let data):
                XCTAssertEqual(data.name, name)
                XCTAssertTrue(data.items.count == expectedCount)
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 3, handler: nil)
    }

    func testSearchEmptyString() throws {
        search("", expectedCount: 82)
    }

    func testSearchLuke() throws {
        search("Luke", expectedCount: 1)
    }

    func testSearchNonExisting() throws {
        search("Non Existing", expectedCount: 0)
    }

    func testPerformanceExample() throws {
        // the first request should store a result in a cache
        search("A", expectedCount: 58)
        self.measure {
            search("A", expectedCount: 58)
        }
    }

}
