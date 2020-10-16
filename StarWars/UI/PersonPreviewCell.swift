
import UIKit

class CharacterPreviewCell: UITableViewCell {
    
    var urlTag: String?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var overview: UILabel!
    
    override func prepareForReuse() {
        activityIndicator.stopAnimating()
        poster.image = nil
        name.text = ""
        overview.text = ""
    }
    
}
