//
//  SceneViewController.swift
//  BuildAR
//
//  Created by Deon Lee on 16/7/19.
//  Copyright © 2019 Tay Jin Wen. All rights reserved.
//

import UIKit
import SceneKit

class SceneViewController: UIViewController {
    
    @IBOutlet weak var itemView: UIView!
    @IBOutlet weak var animalView: UIView!
    @IBOutlet weak var vehicleView: UIView!
    
    var sceneView:SCNView!
    var scene:SCNScene!
    
    var objectScale =  ["dog": SCNVector3(0.02, 0.02, 0.02),
                        "cat": SCNVector3(0.02, 0.02, 0.02),
                        "zebra": SCNVector3(0.2, 0.2, 0.2),
                        "lion": SCNVector3(0.3, 0.3, 0.3),
                        "spaceship": SCNVector3(0.08, 0.08, 0.08),
                        "helicopter": SCNVector3(0.001, 0.001, 0.001),
                        "train": SCNVector3(1, 1, 1),
                        "taxi": SCNVector3(1, 1, 1)]
    
    
    override func viewDidLoad() {
        setupScene()
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        if objectNode == "helicopter" {
            createObject(position: SCNVector3(-4, 1, 0))
        } else {
            createObject(position: SCNVector3(1, 1, 0))
        }
        
        let tapGestureRecognizer = UIGestureRecognizer(target: self, action: #selector(handleTap))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func setupScene(){
        
        
        sceneView = (self.view as! SCNView)
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
        scene = SCNScene(named: "art.scnassets/SceneKit/mainScene.scn")
        sceneView.scene = scene
        
    }
    
    @objc func handleTap(sender: UIGestureRecognizer) {
        
        // Identify location of tap in real world
        let tappedView = sender.view as! SCNView
        let touchLocation = sender.location(in: tappedView)
        let hitTest = tappedView.hitTest(touchLocation, options: nil)
        
        guard let hitResult = hitTest.first else {
            return
        }
        let hitTransform = hitResult.modelTransform
        var hitVector = SCNVector3Make(hitTransform.m41, hitTransform.m42, hitTransform.m43)
        
        if hitResult.node.name == "helicopter" {
            hitVector.x -= 1
        }
        
        objectScene = "art.scnassets/dog/dog.scn"
        objectNode = "dog"
        print("tap")
        createObject(position: hitVector)
    }
    
    func createObject(position: SCNVector3) {
        
        guard let createScene = SCNScene(named: objectScene) else {
            return
        }
        guard let createNode = createScene.rootNode.childNode(withName: objectNode, recursively: true) else {
            return
        }
        
        createNode.position = position
        createNode.scale = objectScale[objectNode]!
        sceneView.scene!.rootNode.addChildNode(createNode)
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    
    // MARK: Actions
    
    @IBAction func switchItems(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            print("animal view")
            animalView.alpha = 1//opaque
            vehicleView.alpha = 0//hide other view
        } else {
            print("vehicle view")
            animalView.alpha = 0
            vehicleView.alpha = 1
        }
    }
}
