
import XCTest

class CharacterTests: XCTestCase {

    func testParserValidObject() {
        let json = """
        {
            "birth_year": "19 BBY",
            "eye_color": "blue",
            "films": [
                "https://swapi.co/api/films/1/"
            ],
            "gender": "male",
            "hair_color": "blond",
            "height": "172",
            "homeworld": "https://swapi.co/api/planets/1/",
            "mass": "77",
            "name": "Luke Skywalker",
            "skin_color": "fair",
            "created": "2014-12-09T13:50:51.644000Z",
            "edited": "2014-12-10T13:52:43.172000Z",
            "species": [
                "https://swapi.co/api/species/1/"
            ],
            "starships": [
                "https://swapi.co/api/starships/12/"
            ],
            "url": "https://swapi.co/api/people/1/",
            "vehicles": [
                "https://swapi.co/api/vehicles/14/"
            ]
        }
        """
        
        let data = json.data(using: .utf8)!
        let c = try! JSONDecoder().decode(Character.self, from: data)
        
        XCTAssertEqual(c.name, "Luke Skywalker")
        XCTAssertEqual(c.url, "https://swapi.co/api/people/1/")
        
        XCTAssertEqual(c.height, "172")
        XCTAssertEqual(c.weight, "77")
        XCTAssertEqual(c.birthYear, "19 BBY")
        XCTAssertEqual(c.homeworld, "https://swapi.co/api/planets/1/")
        XCTAssertEqual(c.films, ["https://swapi.co/api/films/1/"])
        XCTAssertEqual(c.species, ["https://swapi.co/api/species/1/"])
        XCTAssertEqual(c.vehicles, ["https://swapi.co/api/vehicles/14/"])
        XCTAssertEqual(c.starships, ["https://swapi.co/api/starships/12/"])
        
        XCTAssertEqual(c.gender, .male)
        XCTAssertEqual(c.hairColors, [Character.Color.blond])
        XCTAssertEqual(c.skinColors, [Character.Color.fair])
        XCTAssertEqual(c.eyeColor, [Character.Color.blue])
    }
    
    func testParserValidIncompleteObject() {
        let json = """
        {
            "birth_year": "19 BBY",
            "eye_color": "blue",
            "gender": "male",
            "hair_color": "blond",
            "height": "172",
            "mass": "77",
            "name": "Luke Skywalker",
            "skin_color": "fair",
            "created": "2014-12-09T13:50:51.644000Z",
            "edited": "2014-12-10T13:52:43.172000Z"
        }
        """
        
        let data = json.data(using: .utf8)!
        let c = try! JSONDecoder().decode(Character.self, from: data)
        
        XCTAssertEqual(c.name, "Luke Skywalker")
        XCTAssertEqual(c.url, nil)
        
        XCTAssertEqual(c.height, "172")
        XCTAssertEqual(c.weight, "77")
        XCTAssertEqual(c.birthYear, "19 BBY")
        XCTAssertEqual(c.homeworld, nil)
        XCTAssertEqual(c.films, nil)
        XCTAssertEqual(c.species, nil)
        XCTAssertEqual(c.vehicles, nil)
        XCTAssertEqual(c.starships, nil)
        
        XCTAssertEqual(c.gender, .male)
        XCTAssertEqual(c.hairColors, [Character.Color.blond])
        XCTAssertEqual(c.skinColors, [Character.Color.fair])
        XCTAssertEqual(c.eyeColor, [Character.Color.blue])
    }

}
