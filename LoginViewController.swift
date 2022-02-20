//  Created by Devashree Kataria on 03/06/20.
//  Copyright © 2020 Devashree Kataria. All rights reserved.
import UIKit
import Firebase
class LoginViewController: UIViewController {    
    @IBOutlet weak var emailTextField: Designed!    
    @IBOutlet weak var passwordTextField: Designed!    
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
      setView()
    }    
    func setView(){
         emailTextField.layer.cornerRadius = 10
         passwordTextField.layer.cornerRadius = 10
         loginButton.layer.cornerRadius = 15
          //Hide Keyboard
     NotificationCenter.default.addObserver(self, selector: #selector(keyboardwilchange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
     NotificationCenter.default.addObserver(self, selector: #selector(keyboardwilchange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
     NotificationCenter.default.addObserver(self, selector: #selector(keyboardwilchange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
     }   
    func loginUser() {
        let email = emailTextField.text!
        let password = passwordTextField.text!        
        if email.count == 0 && password.count == 0 {
            // create the alert
            let alert = UIAlertController(title: "Invalid!!!", message: "Please enter the email and password!", preferredStyle: UIAlertController.Style.alert)            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            //hide loader
            CustomLoader.instance.hideLoaderView()
        }
        else
        {
            checkNewtork(ifError: "Network Error!")
            loader()
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if error == nil{
                    self.performSegue(withIdentifier: "goToHome", sender: self)
                }
                else{
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                    //hide loader
                    CustomLoader.instance.hideLoaderView()
                }
            }            
            // to start the gif loader
            //CustomLoader.instance.showLoaderView()
        }
    }
    func loader(){
           CustomLoader.instance.gifName = "demo"
           CustomLoader.instance.showLoaderView()
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
        view.frame.origin.y = -210
        loginButton.isHidden = true
    }
    //UITextFieldDeligate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        loginButton.isHidden = false
        return true
    }
    //Hide when touch outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
         view.frame.origin.y = 0
        loginButton.isHidden = false
    }
}
