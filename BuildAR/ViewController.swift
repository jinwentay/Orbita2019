//
//  ViewController.swift
//  BuildAR
//
//  Created by Tay Jin Wen on 5/6/19.
//  Copyright © 2019 Tay Jin Wen. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import Firebase

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Upload an image
        /*
        let image = UIImage(named: "1")
        let imageData = image?.jpegData(compressionQuality: 0.8)!
        uploadImageToFirebaseStorage(data: imageData! as NSData)
        */
 
        // Set the view's delegate
       /* sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene*/
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
//        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        //sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        //sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    // MARK: Actions
    @IBAction func create(_ sender: UIButton) {
//        print("create pressed")
    }
    
    // MARK: Functions
    func uploadImageToFirebaseStorage(data: NSData) {
        let storageRef = Storage.storage().reference(withPath: "myPics/demoPic.jpeg")
        let uploadMeta = StorageMetadata()
        uploadMeta.contentType = "image/jpeg"
        storageRef.putData(data as Data, metadata: uploadMeta) { (metadata, error) in
            if (error != nil) {
                print("I received an error! \(String(describing: error?.localizedDescription))")
            } else {
                print("Upload complete! Here's some metadata! \(String(describing: metadata))")
            }
        }
    }
    
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
