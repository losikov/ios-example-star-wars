
import UIKit

/// UI Object to Show a face for character (lego based image)
class CharacterSmartImage: UIView {
    
    @IBOutlet weak var face: UIImageView!
    @IBOutlet weak var mouth: UIImageView!
    @IBOutlet weak var hair: UIImageView!
    @IBOutlet weak var eye: UIImageView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViewFromNib()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initViewFromNib()
    }

    private func initViewFromNib() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        resetUI()
    }

    private func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CharacterSmartImage", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    private func resetUI() {
        face.isHidden = false
        face.image = nil

        mouth.isHidden = false
        mouth.image = nil

        hair.isHidden = false
        hair.image = nil

        eye.isHidden = false
        eye.image = nil
    }
    
    func prepareForReuse() {
        resetUI()
    }
    
    func configure(with character: Character) {
        face.image = UIImage(named: "face")?.withRenderingMode(.alwaysTemplate)
        let skinColors = character.skinColors.isEmpty ? [Character.Color.fair] : character.skinColors
        face.tintColor = UIColor.mixColors(colors: skinColors.map{UIColor(rgb: $0.hex)})
        
        mouth.image = UIImage(named: "mouth")?.withRenderingMode(.alwaysTemplate)
        mouth.tintColor = .red

        if !character.hairColors.isEmpty {
            let hairImageName = character.gender == .none ? "hair" : "hair_\(character.gender.rawValue)"
            hair.image = UIImage(named: hairImageName)?.withRenderingMode(.alwaysTemplate)
            hair.tintColor = UIColor.mixColors(colors: character.hairColors.map{UIColor(rgb: $0.hex)})
        }

        let eyesImageName = character.gender == .none ? "eyes" : "eyes_\(character.gender.rawValue)"
        eye.image = UIImage(named: eyesImageName)?.withRenderingMode(.alwaysTemplate)
        let eyeColors = character.eyeColor.isEmpty ? [Character.Color.black] : character.eyeColor
        eye.tintColor = UIColor.mixColors(colors: eyeColors.map{UIColor(rgb: $0.hex)})
    }
    
}
