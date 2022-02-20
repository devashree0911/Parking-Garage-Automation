import UIKit
import Firebase
class SignUpViewController: UIViewController {    
    var ref : DatabaseReference?
    var userEmail : String?
    @IBOutlet weak var nameTextField: Designed!    
    @IBOutlet weak var lastNameTextField: Designed!    
    @IBOutlet weak var emailTextField: Designed!    
    @IBOutlet weak var passwordTextField: Designed!
    @IBOutlet weak var signUpButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        checkNewtork(ifError: "Network Error!")
        setView()
    }     
    @IBAction func signUpTapped(_ sender: UIButton) {
        createUser()              
    }
    func setView(){
        nameTextField.layer.cornerRadius = 10
       lastNameTextField.layer.cornerRadius = 10
        emailTextField.layer.cornerRadius = 10
        passwordTextField.layer.cornerRadius = 10
        signUpButton.layer.cornerRadius = 15
        //Hide Keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardwilchange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardwilchange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardwilchange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }   
    func createUser(){
        loader()
        let email = emailTextField.text!
        let password = passwordTextField.text!
        if (email != "" && password != ""){
            loader()
            checkNewtork(ifError: "Network Error!")
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if((error) != nil){
                    print("user already exists")
                    let alert = UIAlertController(title: "Invalid!", message: "The Email is registered with another user", preferredStyle: UIAlertController.Style.alert)

                                      // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        // show the alert
                        self.present(alert, animated: true, completion: nil)
                     CustomLoader.instance.hideLoaderView()
                }else{
                self.sendData()
                }               
            }           
        }
        else{
            let alert = UIAlertController(title: "Invalid!", message: "Please enter your valid emailID and password should of morethan 6 characters!", preferredStyle: UIAlertController.Style.alert)

                     // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                     // show the alert
                self.present(alert, animated: true, completion: nil)
            CustomLoader.instance.hideLoaderView()
        }
    }    
    func sendData(){
        self.ref = Database.database().reference()
             
                guard let uid = Auth.auth().currentUser?.uid else { return }
                if self.nameTextField.text != "" && self.lastNameTextField.text != ""{
                    
        userEmail = emailTextField.text!.replacingOccurrences(of: ".", with: "_")
                
                    self.ref?.child("users").child(userEmail!).setValue(["Name" : self.nameTextField.text, "RegNo" : self.lastNameTextField.text,"Count":0,"Upload":0])
                
                    CustomLoader.instance.hideLoaderView()
                    self.performSegue(withIdentifier: "goToVerified", sender: self)
                }
                else
                {                    
                    // create the alert
                    let alert = UIAlertController(title: "Invalid!r!!", message: "Please fill all the details!", preferredStyle: UIAlertController.Style.alert)

                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                }
    }    
    func loader(){
        CustomLoader.instance.gifName = "demo"
        CustomLoader.instance.showLoaderView()
    }   
    func isPasswordVerified() -> Bool {
        if(passwordTextField.text!.count < 6 ){
            return false
        }
        else{
            return true
        }
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
        signUpButton.isHidden = true
       }
      //UITextFieldDeligate Methods
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           hideKeyboard()
           signUpButton.isHidden = false
           return true
       }
       //Hide when touch outside keyboard
       override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           self.view.endEditing(true)
           view.frame.origin.y = 0
           signUpButton.isHidden = false
       }
}
