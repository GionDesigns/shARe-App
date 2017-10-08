/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController, UITextFieldDelegate {

    // start by default with signup screen
    var signupMode = true
    
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var signinTextBorder: UIImageView!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var signupOrLogin: UIButton!
    
    @IBOutlet weak var changeSignupMode: UIButton!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    @IBAction func signupOrLogin(_ sender: Any) {
        print(signupMode)
        
        if emailTextField.text == "" || passwordTextField.text == "" {
            
            createAlert(title: "Error", message: "Please enter all fields.")
            
            return
            
        } else {
            
            activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            // assuming username and password is entered
            if signupMode {
                // sign up
            
                let user = PFUser()
                
                // need a username for parse, don't need an email but we're asking for it so we'll save it separately
                user.username = usernameTextField.text
                user.email = emailTextField.text
                user.password = passwordTextField.text
                user["bio"] = "Fill me in"
                user["phoneNumber"] = "Fill me in"
                
                
                user.signUpInBackground(block: { (success, error) in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if error != nil {
                        
                        var displayErrorMessage = "Please try again later."
                        /*
                        if let errorMessage = error?.userInfo["error"] as? String {
                            
                            displayErrorMessage = errorMessage
                            
                        } */
                        
                        self.createAlert(title: "Signup Error", message: displayErrorMessage)
                        return
                        
                    } else {
                        
                        print("User signed up.")
                        
                        self.performSegue(withIdentifier: "shAReCameraView", sender: self)
                        
                    }
                
                })
            
            } else {
                
                // login mode
                
                PFUser.logInWithUsername(inBackground: emailTextField.text!, password: passwordTextField.text!, block: { (user, error) in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if error != nil {
                        
                        var displayErrorMessage = "Please try again later."
                        /*
                         if let errorMessage = error?.userInfo["error"] as? String {
                         
                         displayErrorMessage = errorMessage
                         
                         } */
                        
                        self.createAlert(title: "Login Error", message: displayErrorMessage)
                        
                        return
                        
                    } else {
                        
                        print("Logged in!")
                        
                        self.performSegue(withIdentifier: "shAReCameraView", sender: self)
                        
                    }
                    
                })
                
            }
        
        
        
        }
        
        
    }
    
    
    
    
    @IBAction func changeSignupMode(_ sender: Any) {
        
        if signupMode {
            // chcange to login mode
            signupOrLogin.setTitle("Log In", for: [])
            
            changeSignupMode.setTitle("Sign Up", for: [])
            
            usernameTextField.isHidden = true
            signinTextBorder.isHidden = true
            
            messageLabel.text = "Don't have an account?"
            
            signupMode = false
            
        } else {
            // change to signup mode
            signupOrLogin.setTitle("Sign Up", for: [])
            
            changeSignupMode.setTitle("Log In", for: [])
            
            usernameTextField.isHidden = false
            
            signinTextBorder.isHidden = false
        
            messageLabel.text = "Already have an account?"
            
            signupMode = true
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        if PFUser.current() != nil {
            
            performSegue(withIdentifier: "shAReCameraView", sender: self)
            print("is this coming up now")
            
        }
        
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // PFObject is a Prase Framework object
        // let testObject = PFObject(className: "TestObject2")
        // set values of object like a dictionary
        // testObject["foo"] = "bar"
        // save the objects on parse server
        // testObject.saveInBackground { (success, error) -> Void in
            /*
            let nameObject = PFObject(className: "Users")
            nameObject["name"] = "jake"
            nameObject.saveInBackground { (success, error) -> Void in
            
            // added test for success 11th July 2016
            
            if success {
                
                print("Object has been saved.")
                
            } else {
                
                if error != nil {
                    
                    print (error)
                    
                } else {
                    
                    print ("Error")
                }
                
            }
            
        } */
        
        // setting delegates for text field
        
        self.emailTextField.delegate = self ;
        self.passwordTextField.delegate = self ;
        self.usernameTextField.delegate = self ;
        
        
        // screen liftin with keyboard appearing - https://stackoverflow.com/questions/26070242/move-view-with-keyboard-using-swift
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
      
        
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    // Remove keyboard when touching background screen - https://medium.com/@KaushElsewhere/how-to-dismiss-keyboard-in-a-view-controller-of-ios-3b1bfe973ad1
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
