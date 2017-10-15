//
//  profileSettingsViewController.swift
//  shAReApp
//
//  Created by Pascal Couturier on 8/10/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class profileSettingsViewController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate {
    
    var activityIndicator = UIActivityIndicatorView()
    
    var currentUser = PFUser.current()
    
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    @IBOutlet weak var emailProfileSettings: UITextField!
    
    @IBOutlet weak var phoneNumberProfileSettings: UITextField!
    
    @IBOutlet weak var passwordProfileSettings: UITextField!
    
    @IBAction func updateProfileSettingsButton(_ sender: Any) {
        
        if passwordProfileSettings.text == "" {
            createAlert(title: "error", message: "Please enter password to update")
            return
        } else {
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        if let currentUser = PFUser.current() {
            currentUser.email = emailProfileSettings.text
            currentUser["phoneNumber"] = phoneNumberProfileSettings.text
            currentUser.password = passwordProfileSettings.text
            
            currentUser.saveInBackground { (success, error) in
                
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                
                if error != nil {
                    
                    self.createAlert(title: "Couldn't update your details", message: "Please try again later.")
                    
                } else {
                    
                    self.createAlert(title: "Details Updated", message: "Your personal details have been updated!")
                    
                }
                
            }
            
            
        }
        }}
    
    @IBAction func logoutProfileSettings(_ sender: Any) {
        
        PFUser.logOut()
        
        performSegue(withIdentifier: "lougoutProfileSettingsSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        emailProfileSettings.text = PFUser.current()?.email
        phoneNumberProfileSettings.text = currentUser?["phoneNumber"] as! String
        
        // screen liftin with keyboard appearing - https://stackoverflow.com/questions/26070242/move-view-with-keyboard-using-swift
        
        self.emailProfileSettings.delegate = self ;
        self.phoneNumberProfileSettings.delegate = self ;
        self.passwordProfileSettings.delegate = self ;
        
        NotificationCenter.default.addObserver(self, selector: #selector(profileSettingsViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(profileSettingsViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
