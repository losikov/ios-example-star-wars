
import XCTest

class ObjectTests: XCTestCase {

    func testCharacter() {
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
        let c = try! Object.decodeToObjectWith(url: "https://swapi.co/api/people/1/", from: data) as! Character
        
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
    
    func testPlanet() {
        let json = """
        {
            "edited": "2014-12-20T20:58:18.411Z",
            "climate": "arid",
            "surface_water": "1",
            "name": "Tatooine",
            "diameter": "10465",
            "rotation_period": "23",
            "created": "2014-12-09T13:50:49.641Z",
            "terrain": "desert",
            "gravity": "1 standard",
            "orbital_period": "304",
            "population": "200000"
        }
        """
        
        let data = json.data(using: .utf8)!
        let c = try! Object.decodeToObjectWith(url: "https://swapi.co/api/planets/1/", from: data)
        
        XCTAssertEqual(c.name, "Tatooine")
    }
    
    func testFilm() {
        let json = """
        {
            "producer": "Gary Kurtz, Rick McCallum",
            "title": "A New Hope",
            "created": "2014-12-10T14:23:31.880Z",
            "episode_id": 4,
            "director": "George Lucas",
            "release_date": "1977-05-25",
            "opening_crawl": "It is a period of civil war. Rebel spaceships, striking from a hidden base, have won their first victory against the evil Galactic Empire. During the battle, Rebel spies managed to steal secret plans to the Empire's ultimate weapon, the DEATH STAR, an armored space station with enough power to destroy an entire planet. Pursued by the Empire's sinister agents, Princess Leia races home aboard her starship, custodian of the stolen plans that can save her people and restore freedom to the galaxy...."
        }
        """
        
        let data = json.data(using: .utf8)!
        let c = try! Object.decodeToObjectWith(url: "https://swapi.co/api/films/1/", from: data)
        
        XCTAssertEqual(c.name, "A New Hope")
    }

}
