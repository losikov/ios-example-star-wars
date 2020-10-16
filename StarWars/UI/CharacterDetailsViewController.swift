
import UIKit

class CharacterDetailsViewController: UIViewController {

    public var character: Character?
    
    @IBOutlet weak var height: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var birthYear: UILabel!
    
    @IBOutlet weak var homeworld: UILabel!
    @IBOutlet weak var films: UILabel!
    @IBOutlet weak var species: UILabel!
    @IBOutlet weak var vehicles: UILabel!
    @IBOutlet weak var starships: UILabel!
    
    @IBOutlet weak var smartImage: CharacterSmartImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let character = self.character else {
            return
        }
        
        title = character.name ?? ""
        
        configure(with: character)
    }
    
    func configure(with character: Character) {
        height.text = character.height
        weight.text = character.weight
        birthYear.text = character.birthYear
        
        let homeworlds = character.homeworld != nil ? [character.homeworld!] : nil
        homeworld.attributedText = attributedText(name: "Homeworld: ", value: stringFrom(urls: homeworlds))
        films.attributedText = attributedText(name: "Films: ", value: stringFrom(urls: character.films))
        species.attributedText = attributedText(name: "Species: ", value: stringFrom(urls: character.species))
        vehicles.attributedText = attributedText(name: "Vehicles: ", value: stringFrom(urls: character.vehicles))
        starships.attributedText = attributedText(name: "Starships: ", value: stringFrom(urls: character.starships))
        
        smartImage.configure(with: character)
    }
    
    /// Create an attributedText in a format "**name:** value"
    private func attributedText(name: String, value: String) -> NSAttributedString {
        let boldAttribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]
        let text = NSMutableAttributedString(string: name, attributes: boldAttribute)
        text.append(NSAttributedString(string: value))
        return text
    }
    
    /// For a list of urls (optional) returns  "none" or "Name1, Name2, loading, Name3"
    private func stringFrom(urls: [String]?) -> String {
        return urls != nil && urls!.count != 0 ? namesFrom(urls: urls!) : "none"
    }
    
    /// From a list of urls create a string like "Name1, Name2, loading, Name3",
    /// using a real name for loaded objects and "loading" for fetching objects.
    /// Requests the required objects in background.
    /// *setNeedsDisplay* called when objects are loaded
    /// - parameter urls: list of urls
    /// - returns: string like  "Name1, Name2, loading, Name3"
    private func namesFrom(urls: [String]) -> String {
        var names = [String]()
        for url in urls {
            let object = ObjectLoader.shared.load(for: url) {
                [weak self] response in
                switch response {
                case .error(let error):
                    // TODO: display error to user
                    print("Error: '\(error)'.")
                case .data(_):
                    if let character = self?.character {
                        self?.configure(with: character)
                        self?.view.setNeedsDisplay()
                    }
                    
                }
            }
            
            let name = object?.name ?? "loading"
            names.append(name)
        }
        return names.joined(separator: ", ")
    }
}
