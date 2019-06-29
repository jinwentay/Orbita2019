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

var objectScene: String = ""
var objectNode: String = ""

var images = ["animal": "Dog",
              "vehicle": "ship",
              "taxi": "taxi"]

class ARViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet weak var itemView: UIView!
    @IBOutlet weak var animalView: UIView!
    @IBOutlet weak var vehicleView: UIView!
    @IBOutlet weak var objectImage: UIImageView!
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var buildButton: UIButton!
    @IBOutlet weak var answerView: UIView!
    @IBOutlet weak var choiceView: UIStackView!
    @IBOutlet weak var nextView: UIStackView!
    @IBOutlet weak var resultImage: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var labelA: UILabel!
    @IBOutlet weak var labelB: UILabel!
    @IBOutlet weak var labelC: UILabel!
    @IBOutlet weak var labelD: UILabel!
    
    @IBOutlet var sceneView: ARSCNView!
    
    let configuration = ARWorldTrackingConfiguration()
    let roofRef = Database.database().reference()
    
    var questionBranch = "animal"
    var questionID = 0
    
    
    
    var objectSet = Set<String>()
    var inBuidingMode: Bool = true
    var text = ""
    var currentButton: UIButton? = nil
    var numberOfQuestions = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints] //, ARSCNDebugOptions.showWorldOrigin]
        self.sceneView.session.run(configuration)
        self.sceneView.autoenablesDefaultLighting = true
        
        // Recognize taps
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
        
        // Settings for buttons
        doneButton.layer.cornerRadius = doneButton.frame.height / 2
        buildButton.layer.cornerRadius = buildButton.frame.height / 2
    }
    
    override func viewDidAppear(_ animated: Bool) {
        createAlert(title: "Welcome", message: "Select an object, then tap the screen to place it")
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
            let name = result.node.name
            print("tapped \(String(describing: name))")
            
            // In Buiding mode
            if inBuidingMode{
                createObject(position: hitVector)
            }
            // In Quiz mode
            else if objectSet.contains(name ?? "null") {
                
                question.isHidden = false
                answerView.isHidden = false
                
                // Set the catagory of question
                questionBranch = name!
                let dataRef = roofRef.child("\(questionBranch)")
                dataRef.observe(.value) { (snap: DataSnapshot) in
                    
                    // Get the number of questions in the catagory
                    self.numberOfQuestions = Int(snap.childrenCount)
                    self.generateQuestion()
                }
                self.generateImage(objectID: name ?? "AppIcon")
            }
            // No object tapped
            else {
                question.isHidden = true
                answerView.isHidden = true
                print("not object")
            }
        } else {
            question.isHidden = true
            answerView.isHidden = true
            print("hitTest is empty")
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
        
        // Comment out later (for simulation debugging)
        question.isHidden = false
        answerView.isHidden = false
        
        let dataRef = roofRef.child("\(questionBranch)")
        dataRef.observe(.value) { (snap: DataSnapshot) in
            
            self.numberOfQuestions = Int(snap.childrenCount)
            self.generateQuestion()
        }
    }
    
    // Goes into building mode
    @IBAction func build(_ sender: UIButton) {
        resetButton.isHidden = false
        doneButton.isHidden = false
        buildButton.isHidden = true
        question.isHidden = true
        answerView.isHidden = true
        itemView.isHidden = false
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
    
    @IBAction func answer(_ sender: UIButton) {
        
        self.currentButton = sender
        
        // Darken selected button
        currentButton?.alpha = 0.5
        
        // Disable choice selection
        choiceView.isUserInteractionEnabled = false
        
        // Hide next button
        nextButton.isHidden = false
        
        // Retrieve choice text
        guard let choiceButtonPressed = sender.currentTitle else {return}
        let choiceButton = "choice" + choiceButtonPressed
        let choiceRef = roofRef.child("\(questionBranch)/qn\(questionID)/\(String(describing: choiceButton))")
        choiceRef.observe(.value) { (snap: DataSnapshot) in
            let choice = snap.value as? String
            
            // Check user choice against answer
            self.checkAnswer(choice: choice!)
        }
        
    }

    @IBAction func next(_ sender: UIButton) {
        
        // Reset selected button
        currentButton?.alpha = 1
        
        // Enable choice selection
        choiceView.isUserInteractionEnabled = true
        
        // Unhide next button
        nextButton.isHidden = true
        
        // Hide the tick or cross
        self.resultImage.image = nil
        
        generateQuestion()
    }
    
    @IBAction func back(_ sender: UIButton) {
        question.isHidden = true
        answerView.isHidden = true
        
        // Reset the question view
        next(nextButton)
    }
    
    //MARK: Functions
    
    func checkAnswer(choice: String) {
        
        // Retrieve answer
        let answerRef = roofRef.child("\(questionBranch)/qn\(questionID)/answer")
        answerRef.observe(.value) { (snap: DataSnapshot) in
            let answer = snap.value as? String
            
            print("answer is: \(String(describing: snap.value)))")
            
            // Check if answer is correct
            if choice == answer {
                print("Correct!")
                self.resultImage.image = UIImage(named: "Correct")
            } else {
                print("Wrong answer")
                self.resultImage.image = UIImage(named: "Wrong")
            }
        }
    }
    
    func generateQuestion() {
        
        // Get a new question
        questionID = Int.random(in: 1...numberOfQuestions)
        
        // Set text for question label and for each choice label
        labelTextFromFirebase(key: "question", label: self.question)
        labelTextFromFirebase(key: "choiceA", label: self.labelA)
        labelTextFromFirebase(key: "choiceB", label: self.labelB)
        labelTextFromFirebase(key: "choiceC", label: self.labelC)
        labelTextFromFirebase(key: "choiceD", label: self.labelD)
    }
    
    func labelTextFromFirebase(key: String, label: UILabel) {
        
        // Retrieve text from Firebase
        let referance = roofRef.child("\(questionBranch)/qn\(questionID)/\(key)")
        referance.observe(.value) { (snap: DataSnapshot) in
            label.text = snap.value as? String
        }
    }
    //set object image when object is tapped for quiz section
    func generateImage(objectID: String) {
        let selectedImage = images[objectID]
        self.objectImage.image = UIImage(named: selectedImage ?? "AppIcon")
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
    
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Got it!", style: UIAlertAction.Style.default, handler: {
            (action) in
            alert.dismiss(animated:true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

