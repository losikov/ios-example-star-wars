
import UIKit

class PersonDetailsViewController: UIViewController {

    public var movie: Person?
    
    @IBOutlet weak var movieTitle: UILabel!
    
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var overview: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let movie = self.movie else {
            return
        }
        
        movieTitle.text = movie.name ?? ""
//        movieTitle.accessibilityIdentifier = "title"
        
//        overview.text = movie.overview ?? ""
//        overview.accessibilityIdentifier = "overview"

//        if let imageUrl = movie.imageUrlString() {
//            print(imageUrl)
//            poster.loadImageWithUrl(string: imageUrl,
//                                    placeholder: #imageLiteral(resourceName: "poster_placeholder"),
//                                    startedHandler: {
//                                        activityIndicator.startAnimating()
//                                    },
//                                    completionHandler: {[weak self] image in
//                                        self?.activityIndicator.stopAnimating()
//                                        self?.poster.image = image
//                                    })
//        } else {
//            poster.image = #imageLiteral(resourceName: "poster_placeholder")
//        }
    }
    
}

