
import UIKit

class CharacterPreviewCell: UITableViewCell {
    
    var urlTag: String?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var height: UILabel!
    @IBOutlet weak var birthYear: UILabel!
    
    @IBOutlet weak var smartImage: CharacterSmartImage!
    
    override func prepareForReuse() {
        activityIndicator.stopAnimating()
        
        name.text = ""
        weight.text = ""
        height.text = ""
        birthYear.text = ""
        
        smartImage.prepareForReuse()
    }
    
    func configure(with character: Character?) {
        guard let character = character else {
            activityIndicator.startAnimating()
            return
        }
        
        name.text = character.name ?? ""
        weight.text = character.weight == "unknown" ? "~" : character.weight ?? ""
        height.text = character.height == "unknown" ? "~" : character.height ?? ""
        birthYear.text = character.birthYear == "unknown" ? "~" : character.birthYear ?? ""

        smartImage.configure(with: character)
    }
    
}
