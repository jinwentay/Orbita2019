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
import FirebaseDatabase
import Firebase

var mainViewController = ARViewController()

var objectScene: String = ""
var objectNode: String = ""
var objectName: String = ""

var questionBranch = "animal"
var questionID = 0
//var numberOfQuestions = 0

var images = ["animal": "Dog",
              "vehicle": "ship",
              "taxi": "taxi"]

class ARViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet weak var itemView: UIView!
    @IBOutlet weak var animalView: UIView!
    @IBOutlet weak var vehicleView: UIView!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var buildButton: UIButton!
    @IBOutlet weak var quizContainerView: UIView!
    
    @IBOutlet var sceneView: ARSCNView!
    
    let configuration = ARWorldTrackingConfiguration()
    let roofRef = Database.database().reference()
    
    var objectSet = Set<String>()
    var inBuidingMode: Bool = true
    var text = ""
    var currentButton: UIButton? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        self.sceneView.session.run(configuration)
        self.sceneView.autoenablesDefaultLighting = true
        
        mainViewController = self
        
        // Recognize taps
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
        
        // Settings for buttons
        doneButton.layer.cornerRadius = doneButton.frame.height / 2
        buildButton.layer.cornerRadius = buildButton.frame.height / 2
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //createAlert(title: "Welcome", message: "Select an object, then tap on one of the yellow dots on the screen to place it!")
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer){
        
        // Identify location of tap in real world
        let tappedView = sender.view as! SCNView
        let touchLocation = sender.location(in: tappedView)
        let hitTest = tappedView.hitTest(touchLocation, options: nil)
        
        let result = sceneView.hitTest(touchLocation, types: ARHitTestResult.ResultType.estimatedHorizontalPlane)
        guard let hitResult = result.last else {
            return
        }
        let hitTransform = hitResult.worldTransform
        let hitMat = SCNMatrix4(hitTransform)
        let hitVector = SCNVector3Make(hitMat.m41, hitMat.m42, hitMat.m43)
        
        
        // When the hit test is not empty
        if !hitTest.isEmpty {
            let result = hitTest.first!
            let node = result.node
            objectName = node.name ?? "AppIcon"
            //print("tapped \(String(describing: objectName))")
            
            // In Buiding mode
            if inBuidingMode{
                createObject(position: hitVector)
            }
            // In Quiz mode
            else if objectSet.contains(objectName ) {
                
                // Rotate selected object
                let action = SCNAction.rotateBy(x: 0, y: 1, z: 0, duration: 1)
                let forever = SCNAction.repeatForever(action)
                node.runAction(forever)
                
                // Show quiz
                quizContainerView.isHidden = false
                
                // Set the catagory of question
                questionBranch = objectName
                let dataRef = roofRef.child("\(questionBranch)")
                dataRef.observe(.value) { (snap: DataSnapshot) in
                    
                    // Get the number of questions in the catagory
                    let numberOfQuestions = Int(snap.childrenCount)
                    questionID = Int.random(in: 1...numberOfQuestions)

                }
            }
            // No object tapped
            else {
                quizContainerView.isHidden = true
                //print("not object")
            }
        } else {
            quizContainerView.isHidden = true
            //print("hitTest is empty")
        }
    }
    
    //MARK: Actions
    
    // Goes into quiz mode
    @IBAction func done(_ sender: UIButton) {
        resetButton.isHidden = true
        doneButton.isHidden = true
        buildButton.isHidden = false
        itemView.isHidden = true
        inBuidingMode = false
        
        // COMMENT OUT LATER
        //quizContainerView.isHidden = false
    }
    
    // Goes into building mode
    @IBAction func build(_ sender: UIButton) {
        resetButton.isHidden = false
        doneButton.isHidden = false
        buildButton.isHidden = true
        quizContainerView.isHidden = true
        itemView.isHidden = false
        quizContainerView.isHidden = true
        inBuidingMode = true
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
        self.resetSession()
    }
    
    
    //MARK: Functions
    
    func labelTextFromFirebase(key: String, label: UILabel) {
        
        // Retrieve text from Firebase
        let referance = roofRef.child("\(questionBranch)/qn\(questionID)/\(key)")
        referance.observe(.value) { (snap: DataSnapshot) in
            label.text = snap.value as? String
        }
    }
 
    func createObject(position: SCNVector3) {
        
        guard let createScene = SCNScene(named: objectScene) else {
            return
        }
        guard let createNode = createScene.rootNode.childNode(withName: objectNode, recursively: true) else {
            return
        }
        createNode.position = position
        sceneView.scene.rootNode.addChildNode(createNode)
        objectSet.insert(objectNode)
    }
    
    func resetSession() {
        self.sceneView.session.pause()
        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
        self.sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    func hideQuizView () {
        self.quizContainerView.isHidden = true
    }
    
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Got it!", style: UIAlertAction.Style.default, handler: {
            (action) in
            alert.dismiss(animated:true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

