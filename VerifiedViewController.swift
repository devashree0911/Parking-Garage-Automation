import UIKit
class VerifiedViewController: UIViewController {
    @IBOutlet weak var GifView: UIImageView!    
    @IBOutlet weak var continueButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
    func setView(){          
           GifView.loadGif(name: "Verified")
           continueButton.layer.cornerRadius = 15
       }
}
