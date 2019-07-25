//
//  SceneViewController.swift
//  BuildAR
//
//  Created by Deon Lee on 16/7/19.
//  Copyright © 2019 Tay Jin Wen. All rights reserved.
//

import UIKit
import SceneKit

var sceneViewController = SceneViewController()

class SceneViewController: UIViewController, SCNSceneRendererDelegate {
    
    @IBOutlet weak var itemView: UIView!
    @IBOutlet weak var animalView: UIView!
    @IBOutlet weak var vehicleView: UIView!
    @IBOutlet weak var sceneView: SCNView!
    @IBOutlet weak var rotateRightButton: UIButton!
    @IBOutlet weak var rotateLeftButton: UIButton!
    @IBOutlet weak var quizButton: UIButton!
    @IBOutlet weak var buildButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var arrowsView: UIView!
    @IBOutlet weak var leftArrow: UIButton!
    @IBOutlet weak var quizContainerView: UIView!
    
    var scene:SCNScene!
    var selectedObject: SCNNode!
    var inBuildingMode = true
    var marker = SCNNode(geometry: SCNBox(width: 1, height: 0.1, length: 1, chamferRadius: 0.1))
    var objectScale =  ["dog": SCNVector3(0.02, 0.02, 0.02),
                        "cat": SCNVector3(0.025, 0.025, 0.025),
                        "zebra": SCNVector3(0.17, 0.17, 0.17),
                        "lion": SCNVector3(0.3, 0.3, 0.3),
                        "spaceship": SCNVector3(0.08, 0.08, 0.08),
                        "helicopter": SCNVector3(0.005, 0.005, 0.005),
                        "train": SCNVector3(2, 2, 2),
                        "taxi": SCNVector3(1, 1, 1)]
    var objectEuler =  ["dog": SCNVector3(Double.pi / 2, 0, 0),
                        "cat": SCNVector3(Double.pi / 2, 0, 0),
                        "zebra": SCNVector3(0, 0, 0),
                        "lion": SCNVector3(0, 0, 0),
                        "spaceship": SCNVector3(0, 0, 0),
                        "helicopter": SCNVector3(0, Double.pi, 0),
                        "train": SCNVector3(Double.pi / 2, Double.pi * 1.5, 0),
                        "taxi": SCNVector3(Double.pi / 2, Double.pi * 1.5, 0)]
    
    
    override func viewDidLoad() {
        setupScene()
        
        inARMode = false
        sceneViewController = self
        leftArrow.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * 1.5))
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func setupScene(){
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
        scene = SCNScene(named: "art.scnassets/SceneKit/mainScene.scn")
        sceneView.scene = scene
        self.sceneView.delegate = self
        
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        
        // Identify location of tap in real world
        let tapView = sender.view as! SCNView
        let tapLocation = sender.location(in: tapView)
        let hitTest = sceneView.hitTest(tapLocation, options: nil)
        
        guard let hitResult = hitTest.first else {
            return
        }
        let hitNode = hitResult.node
        guard let hitName = hitNode.name else {
            return
        }
        selectedObject = hitNode
        
        // Remove animations
        self.scene.rootNode.enumerateChildNodes { (node, _) in
            node.removeAllActions()
        }
        
        if inBuildingMode {
            handleBuild(hitName: hitName)
        } else {
            handleQuiz(hitName: hitName, hitNode: hitNode)
        }
    }
    
    func handleBuild(hitName: String) {
        if hitName != "floor" {
            rotateRightButton.isHidden = false
            rotateLeftButton.isHidden = false
        } else {
            rotateRightButton.isHidden = true
            rotateLeftButton.isHidden = true
        }
    }
    
    func handleQuiz(hitName: String, hitNode: SCNNode) {
        if hitName != "floor" {
            
            // Rotate selected object
            if hitNode.animationKeys.isEmpty {
                let action = SCNAction.rotateBy(x: 0, y: 1, z: 0, duration: 1)
                let forever = SCNAction.repeatForever(action)
                hitNode.runAction(forever)
            }
            // Show quiz
            questionBranch = hitName
            quizViewController.generateQuestion()
            quizContainerView.isHidden = false
            
        } else {
            questionBranch = "AppIcon"
            quizContainerView.isHidden = true
        }
        
    }
    
    func createObject() {
        let cameraNode = sceneView.pointOfView!
        guard let createScene = SCNScene(named: objectScene) else {
            return
        }
        guard let createNode = createScene.rootNode.childNode(withName: objectNode, recursively: true) else {
            return
        }
        let location = SCNVector3(x: 0, y: 0, z: -6)
        createNode.position = location
        createNode.geometry?.firstMaterial?.lightingModel = SCNMaterial.LightingModel.constant
        
        // Face the object towards the camera and position it in front of camera
        updatePositionAndOrientationOf(createNode, withPosition: location, relativeTo: cameraNode)
        
        createNode.scale = objectScale[objectNode]!
        scene.rootNode.addChildNode(createNode)
        
    }
    
    func updatePositionAndOrientationOf(_ node: SCNNode, withPosition position: SCNVector3, relativeTo referenceNode: SCNNode) {
        let referenceNodeTransform = matrix_float4x4(referenceNode.transform)
        
        // Setup a translation matrix with the desired position
        var translationMatrix = matrix_identity_float4x4
        translationMatrix.columns.3.x = position.x
        translationMatrix.columns.3.y = position.y
        translationMatrix.columns.3.z = position.z
        
        // Combine the configured translation matrix with the referenceNode's transform to get the desired position AND orientation
        let updatedTransform = matrix_multiply(referenceNodeTransform, translationMatrix)
        node.transform = SCNMatrix4(updatedTransform)
        if node.name != "marker" {
            node.eulerAngles.x = objectEuler[objectNode]?.x ?? 0
            node.eulerAngles.y += objectEuler[objectNode]?.y ?? 0
            node.eulerAngles.z = objectEuler[objectNode]?.z ?? 0
        } else {
            node.eulerAngles.x = 0
        }
        node.position.y = 0
        print(node.name ?? "no node")
    }
    
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        // Update position marker
        let cameraNode = sceneView.pointOfView!
        let position = SCNVector3(0, 0, -6)
        marker.geometry?.firstMaterial?.diffuse.contents = UIColor.gray
        marker.position = position
        marker.name = "marker"
        updatePositionAndOrientationOf(marker, withPosition: position, relativeTo: cameraNode)
        scene.rootNode.addChildNode(marker)
    }
    
    func hideQuizView () {
        self.quizContainerView.isHidden = true
        selectedObject.removeAllActions()
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
    
    // Goes into quiz mode
    @IBAction func quiz(_ sender: UIButton) {
        resetButton.isHidden = true
        quizButton.isHidden = true
        buildButton.isHidden = false
        itemView.isHidden = true
        arrowsView.isHidden = true
        rotateLeftButton.isHidden = true
        rotateRightButton.isHidden = true
        
        inBuildingMode = false
//        playSoundButton.isHidden = false
//        stopSoundButton.isHidden = false
    }
    
    // Goes into building mode
    @IBAction func build(_ sender: UIButton) {
        resetButton.isHidden = false
        quizButton.isHidden = false
        buildButton.isHidden = true
        itemView.isHidden = false
        arrowsView.isHidden = false
        
        hideQuizView()
        inBuildingMode = true
//        playSoundButton.isHidden = true
//        stopSoundButton.isHidden = true
    }
    
    @IBAction func switchItems(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            animalView.alpha = 1//opaque
            vehicleView.alpha = 0//hide other view
        } else {
            animalView.alpha = 0
            vehicleView.alpha = 1
        }
    }
    
    @IBAction func reset(_ sender: UIButton) {
        self.sceneView.scene!.rootNode.enumerateChildNodes { (node, _) in
            if node.name != "floor" {
                node.removeFromParentNode()
            }
        }
    }
    
    @IBAction func forward(_ sender: UIButton) {
        sceneView.pointOfView?.position.z -= 1
    }
    
    @IBAction func backward(_ sender: UIButton) {
        sceneView.pointOfView?.position.z += 1
    }
    
    @IBAction func left(_ sender: UIButton) {
        sceneView.pointOfView?.position.x -= 1
    }
    
    @IBAction func right(_ sender: UIButton) {
        sceneView.pointOfView?.position.x += 1
    }
    
    @IBAction func create(_ sender: UIButton) {
        createObject()
    }
    
    @IBAction func rotateRight(_ sender: UIButton) {
        selectedObject.eulerAngles.y += GLKMathDegreesToRadians(15)
    }
    
    @IBAction func rotateLeft(_ sender: UIButton) {
        selectedObject.eulerAngles.y -= GLKMathDegreesToRadians(15)
    }
}
