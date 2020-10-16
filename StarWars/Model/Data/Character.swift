
import Foundation

class Character: Object {
    
    enum Gender: String {
        case male
        case female
        case none
    }

    enum Color: String {
        case blond
        case brown
        case grey
        case black
        case auburn
        case white
        case fair
        case gold
        case light
        case red
        case green
        case pale
        case metal
        case dark
        case orange
        case blue
        case yellow
        case tan
        case silver
        case hazel
        case pink
        
        var hex: Int {
          switch self {
          case .blond:
            return 0xFAF0BE
          case .brown:
            return 0x964B00
          case .grey:
            return 0x808080
          case .auburn:
            return 0x71231D
          case .white:
            return 0xFFFFFF
          case .fair:
            return 0xE6E4E3
          case .gold:
            return 0xFFD700
          case .light:
            return 0xFFE6E3
          case .red:
            return 0xFF0000
          case .green:
            return 0x008000
          case .pale:
            return 0xCFECEC
          case .metal:
            return 0x46473E
          case .dark:
            return 0x4D2A22
          case .orange:
            return 0xFF4500
          case .blue:
            return 0x0000FF
          case .yellow:
            return 0xFFFF00
          case .tan:
            return 0xD2B48C
          case .silver:
            return 0xC0C0C0
          case .hazel:
            return 0xCCC080
          case .pink:
            return 0xFFC0CB
          default:
            return 0x000000
          }
        }
    }
    
    let height: String?      // "172"
    let weight: String?      // "77",
    let birthYear: String?   // "19BBY"
    let homeworld: String?   // "http://swapi.dev/api/planets/1/"
    let films: [String]?     // ["http://swapi.dev/api/films/1/"]
    let species: [String]?   //
    let vehicles: [String]?  // ["http://swapi.dev/api/vehicles/14/"]
    let starships: [String]? // ["http://swapi.dev/api/starships/12/"]
    
    let gender: Gender       // "male" P
    let hairColors: [Color]  // "blond" P
    let skinColors: [Color]  // "fair" P
    let eyeColor: [Color]    // "blue" P
    
    private enum CodingKeys: String, CodingKey {
        case height
        case weight = "mass"
        case hairColor = "hair_color"
        case skinColor = "skin_color"
        case eyeColor = "eye_color"
        case birthYear = "birth_year"
        case gender = "gender"
        case homeworld = "homeworld"
        
        case films
        case species
        case vehicles
        case starships
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        height = try values.decode(String.self, forKey: .height)
        weight = try values.decode(String.self, forKey: .weight)
        birthYear = try values.decode(String.self, forKey: .birthYear)
        homeworld = try? values.decode(String.self, forKey: .homeworld)
        films = try? values.decode(Array.self, forKey: .films)
        species = try? values.decode(Array.self, forKey: .species)
        vehicles = try? values.decode(Array.self, forKey: .vehicles)
        starships = try? values.decode(Array.self, forKey: .starships)
                
        var gender: Gender = .none
        if let genderStr = try values.decodeIfPresent(String.self, forKey: .gender),
           let genderType = Gender(rawValue: genderStr) {
            gender = genderType
        }
        self.gender = gender
        
        var hairColors = [Color]()
        if let colorsStr = try values.decodeIfPresent(String.self, forKey: .hairColor) {
            for colorStr in colorsStr.components(separatedBy: ", ")  {
                if let color = Color(rawValue: colorStr) {
                    hairColors.append(color)
                }
            }
        }
        self.hairColors = hairColors
        
        var skinColors = [Color]()
        if let colorsStr = try values.decodeIfPresent(String.self, forKey: .skinColor) {
            for colorStr in colorsStr.components(separatedBy: CharacterSet(charactersIn: ", -"))  {
                if let color = Color(rawValue: colorStr) {
                    skinColors.append(color)
                }
            }
        }
        self.skinColors = skinColors
        
        var eyeColor = [Color]()
        if let colorsStr = try values.decodeIfPresent(String.self, forKey: .eyeColor) {
            for colorStr in colorsStr.components(separatedBy: ", ")  {
                if let color = Color(rawValue: colorStr) {
                    eyeColor.append(color)
                }
            }
        }
        self.eyeColor = eyeColor

        try super.init(from: decoder)
    }
    
}
