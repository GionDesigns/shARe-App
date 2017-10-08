//
//  shAReCameraViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Pascal Couturier on 28/9/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse
import ARKit
import SceneKit
import MapKit
import CoreLocation

class shAReCameraViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate, ARSKViewDelegate, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        /*
        // screen orientation lock
        AppUtility.lockOrientation(.landscapeRight)
        */
        
        // Do any additional setup after loading the view.
        //navigation bar logo- navigation bar has since been removed so this code is now irrelevant - but link to details - https://www.ioscreator.com/tutorials/customizing-navigation-bar-ios-tutorial-ios10
        /*
         let nav = self.navigationController?.navigationBar
         nav?.barStyle = UIBarStyle.blackOpaque
         nav?.tintColor = UIColor.white
         let imageView = UIImageView(frame: CGRect(x: 0, y:0, width: 40, height: 40))
         imageView.contentMode = .scaleAspectFit
         let image = UIImage(named: "Logo.png")
         imageView.image = image
         
         navigationItem.titleView = imageView
         */
        
        // Set the view's delegate
        sceneView.delegate = self
        
        
        // Show statistics
        
        
        
        // Creating the tap gesture on screen touch function - WWDC 2017 ARKit keynote Demo - PC
        let tapGesture = UITapGestureRecognizer(target: self, action:
            #selector(shAReCameraViewController.handleTap(gestureRecognize:)))
        view.addGestureRecognizer(tapGesture)

    }
    
    @objc
    func handleTap(gestureRecognize: UITapGestureRecognizer) {
        guard let currentFrame = sceneView.session.currentFrame else {
            return
        }
        
        //Make a floating image with using a snapshot of the screen and setting sizes for image - PC
        let floatingImage = SCNPlane(width: sceneView.bounds.width / 6000,
                                     height: sceneView.bounds.height / 6000)
        floatingImage.firstMaterial?.diffuse.contents = sceneView.snapshot()
        
        floatingImage.firstMaterial?.lightingModel = .constant
        
        //Making the node where image is anchored in position - PC
        let planeNode = SCNNode(geometry: floatingImage)
        
        
        
        //set the node to be just infront of camera - PC
        var translation = matrix_identity_float4x4
        translation.columns.3.z = -0.1
        planeNode.simdTransform = matrix_multiply(currentFrame.camera.transform, translation)
        sceneView.scene.rootNode.addChildNode(planeNode)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /*
        // screen orientation lock
        AppUtility.lockOrientation(.landscapeRight)
        */
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()

        /*
        AppUtility.lockOrientation(.portrait)
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

extension ViewController: UIImagePickerControllerDelegate {
    
    
}


extension ViewController: ARSCNViewDelegate{
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
        
    }
}

/* This is for screen orientation locking
struct AppUtility {
    
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    
    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        
        self.lockOrientation(orientation)
        
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
    }

}*/

