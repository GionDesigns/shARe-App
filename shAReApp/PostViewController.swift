//
//  PostViewController.swift
//  ParseStarterProject-Swift
//
//  Created by admin on 19/9/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse
import CoreLocation

class PostViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var activityIndicator = UIActivityIndicatorView()

    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    @IBOutlet weak var imageToPost: UIImageView!
    
    @IBAction func chooseAnImage(_ sender: Any) {
        // when we click on 'choose image' it will take us to the photo library
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            // if we can cast the image we chose as a UIImage, show it in the image view
            imageToPost.image = image
            
        }
        
        // once we've chosen a photo, close photo library
        // remember to change access in info.plist
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBOutlet weak var messageTextField: UITextField!
    
    
    @IBAction func postImage(_ sender: Any) {
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        var post = PFObject(className: "Posts")
        
        post["message"] = messageTextField.text
        post["userID"] = PFUser.current()?.objectId
        // we're going to get the image from the imageToPost outlet
        let imageData = UIImageJPEGRepresentation(imageToPost.image!, 0.1)
        
        let imageFile = PFFile(name: "image.jpeg", data: imageData!)
        
        post["imageFile"] = imageFile
        
        // saving location as well https://stackoverflow.com/questions/30828847/how-to-retrive-location-from-a-pfgeopoint-parse-com-and-swift-and-show-it-on
        
        var locationManager = CLLocationManager()
        
        var lat = locationManager.location?.coordinate.latitude
        var lon = locationManager.location?.coordinate.longitude
        
        let myGeoPoint = PFGeoPoint(latitude: lat!, longitude: lon!)
        let myParseID = PFUser.current()?.objectId
        
        post.setObject(myParseID, forKey: "Who")
        post.setObject(myGeoPoint, forKey: "Where")
        
        post.saveInBackground { (success, error) in
            
            self.activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if error != nil {
                
                self.createAlert(title: "Couldn't post image.", message: "Please try again later.")
                
            } else {
                
                self.createAlert(title: "Image posted!", message: "Your image has been uploaded!")
                
                self.messageTextField.text = ""
                self.imageToPost.image = UIImage(named: "file-default-icon-62367.png")
            }
            
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // screen liftin with keyboard appearing - https://stackoverflow.com/questions/26070242/move-view-with-keyboard-using-swift
        
        NotificationCenter.default.addObserver(self, selector: #selector(PostViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PostViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
