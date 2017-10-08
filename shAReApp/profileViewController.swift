//
//  profileViewController.swift
//  shAReApp
//
//  Created by Pascal Couturier on 29/9/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class profileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var activityIndicator = UIActivityIndicatorView()
    
    var currentUser = PFUser.current()
    
    @IBOutlet weak var emailProfile: UILabel!
    
    @IBOutlet weak var usernameProfile: UITextField!
    
    @IBOutlet weak var bioProfile: UITextField!
    
    @IBOutlet weak var profilePicImage: UIImageView!
    
    
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    @IBAction func changeProfilePic(_ sender: Any) {
        // when we click on 'choose image' it will take us to the photo library
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            // if we can cast the image we chose as a UIImage, show it in the image view
            profilePicImage.contentMode = .scaleToFill
            profilePicImage.image = image
            
        }
        
        // once we've chosen a photo, close photo library
        // remember to change access in info.plist
        picker.dismiss(animated: true, completion: nil)
        
        
    }
    
    @IBAction func updateProfile(_ sender: Any) {
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        var user = PFObject(className: "User")
        
        if let currentUser = PFUser.current() {
            currentUser.username = usernameProfile.text
            currentUser["bio"] = bioProfile.text
            currentUser.email = emailProfile.text
            
            currentUser.saveInBackground()
        }
        
        let imageData = UIImageJPEGRepresentation(profilePicImage.image!, 0.1)
        
        let imageFile = PFFile(name: "profilePic.jpeg", data: imageData!)
        
        currentUser?.setObject(imageFile, forKey: "ProfilePic")
        
        currentUser?.saveInBackground { (success, error) in
            
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if error != nil {
                
                self.createAlert(title: "Couldn't update profile", message: "Please try again later.")
                
            } else {
                
                self.createAlert(title: "Profile Updated", message: "Your Profile has been updated!")
                
            }
            
        }
        
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        usernameProfile.text = PFUser.current()?.username
        bioProfile.text = currentUser?["bio"] as! String
        emailProfile.text = PFUser.current()?.email
        
        // update profile picture - https://stackoverflow.com/questions/31776333/retrieve-avatar-from-user-class-swift-parse
        
        let avatarFile = PFUser.current()!["ProfilePic"] as! PFFile
        avatarFile.getDataInBackground() {
            (imageData:Data?, error:Error?) -> Void in
            if error == nil {
                if let finalimage = UIImage(data: imageData!) {
                    self.profilePicImage.image = finalimage
                }
            }
        }
        /*
        // screen orientation lock
        AppUtility.lockOrientation(.portrait)
        */

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /*
        // screen orientation lock
        AppUtility.lockOrientation(.portrait)
        */
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        /*
        AppUtility.lockOrientation(.landscapeRight)
        */
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

