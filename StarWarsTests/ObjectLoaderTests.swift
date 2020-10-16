
import XCTest

@testable import StarWars

class ObjectLoaderTests: XCTestCase {
    
    private func load(url: String) -> (retObject: StarWars.Object?, handlerObject: StarWars.Object?) {
        let expectation = self.expectation(description: "Success response")
        
        var handlerObject: StarWars.Object?
        let retObject = StarWars.ObjectLoader.shared.load(for: url) { response in
            XCTAssertTrue(Thread.isMainThread, "should call on main thread")
            
            switch response {
            case .error(let error):
                XCTFail(error.localizedDescription)
            case .data(let data):
                handlerObject = data
                XCTAssertEqual(data.url, url)
                expectation.fulfill()
            }
            
        }
        
        if retObject != nil {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3, handler: nil)
        
        return (retObject: retObject, handlerObject: handlerObject)
    }
    
    func testVehicle() {
        let res = load(url: "http://swapi.dev/api/starships/12/")
        XCTAssertNil(res.retObject)
        XCTAssertEqual(res.handlerObject?.name, "X-wing")
    }
    
    func testFilms() {
        let res = load(url: "http://swapi.dev/api/films/6/")
        XCTAssertNil(res.retObject)
        XCTAssertEqual(res.handlerObject?.name, "Revenge of the Sith")
    }
    
    func testPerformanceAndCacheHomeword() throws {
        // the first request should store a result in a cache
        // returned result should be nil, and handler have an object
        let res = load(url: "http://swapi.dev/api/planets/1/")
        XCTAssertNil(res.retObject)
        XCTAssertEqual(res.handlerObject?.name, "Tatooine")
        
        self.measure {
            // returned and handler objects should swap, as they should come from cache
            let res = load(url: "http://swapi.dev/api/planets/1/")
            XCTAssertNil(res.handlerObject)
            XCTAssertEqual(res.retObject?.name, "Tatooine")
        }
    }

}
