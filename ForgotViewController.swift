import UIKit
import Firebase
class ForgotViewController: UIViewController {    
    @IBOutlet weak var emailTextField: Designed!
    @IBOutlet weak var ResetPasswordButton: UIButton!    
    override func viewDidLoad() {
        super.viewDidLoad()
      emailTextField.layer.cornerRadius = 15
            ResetPasswordButton.layer.cornerRadius = 15
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardwilchange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
              NotificationCenter.default.addObserver(self, selector: #selector(keyboardwilchange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
              NotificationCenter.default.addObserver(self, selector: #selector(keyboardwilchange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)            
    }    
    @IBAction func ResetPasswordAction(_ sender: UIButton) {
        if(emailTextField.text != ""){
            checkNewtork(ifError: "Network Error!")
            Auth.auth().sendPasswordReset(withEmail: emailTextField.text!) { error in
                  if error != nil {
                      print(error?.localizedDescription ?? "Error")
                    self.authAlert(titlepass: "Reset failed",message: "Please try again.")                     
                  }
                  else {
                      print("Success!")
                    self.authAlert(titlepass: "Note",message: "Reset password email has been send.")
                    self.performSegue(withIdentifier: "goToLogin", sender: self)                     
                  }
              }
        }else{
            self.authAlert(titlepass: "Invalid!", message: "Please enter valid Email id")
        }
    }    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "goToLogin", sender: self)
    }   
    // MARK: - Code below this is for hiding keyboard
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }    
    func hideKeyboard(){
        view.resignFirstResponder()
    }   
    @objc func keyboardwilchange(notification: Notification){
        view.frame.origin.y = -230
        ResetPasswordButton.isHidden = true
    }    
    //UITextFieldDeligate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        ResetPasswordButton.isHidden = false
        return true
    }    
    //Hide when touch outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        ResetPasswordButton.isHidden = false
         view.frame.origin.y = 0
    }
}
