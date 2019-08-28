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

var questionBranch = "dog" // Remove "animal" (for testing)
var questionID = 0
var factID = 0
var numberOfQuestions = 0
var numberOfFacts = 0

var sounds = ["dog":"dogbark",
              "cat":"catmeow",
              "zebra":"zebracall",
              "lion":"liongrowl",
              "spaceship":"alien",
              "plane":"airplane",
              "motorcycle":"motorcycle",
              "rooster":"rooster",
              "poisonfrog":"poisonfrog"]

class ARViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet weak var itemView: UIView!
    @IBOutlet weak var animalView: UIView!
    @IBOutlet weak var vehicleView: UIView!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var quizButton: UIButton!
    @IBOutlet weak var buildButton: UIButton!
    @IBOutlet weak var quizContainerView: UIView!
    @IBOutlet weak var infoContainerView: UIView!
    @IBOutlet weak var playSoundButton: UIButton!
    @IBOutlet weak var stopSoundButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    
    @IBOutlet var sceneView: ARSCNView!
    
    let configuration = ARWorldTrackingConfiguration()
    let roofRef = Database.database().reference()
    
    var objectSet = Set<String>()
    var inBuidingMode: Bool = true
    var text = ""
    var currentButton: UIButton? = nil
    var selectedNode: SCNNode!
    var audioplayer = AVAudioPlayer()
    
    let alertMessage = ["Select an object, then tap the circle button to place it!",
                        "Tap the question mark to play the quiz",
                        "You can turn off tutorial in settings"]
    let alertTitle = ["Welcome",
                      "Quiz mode",
                      "Tutorial mode"]
    let numberOfMessages = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        self.sceneView.session.run(configuration)
        self.sceneView.autoenablesDefaultLighting = true
        
        mainViewController = self
        inARMode = true
        
        // Recognize taps
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
        
        // Settings for buttons
        quizButton.layer.cornerRadius = quizButton.frame.height / 2
        buildButton.layer.cornerRadius = buildButton.frame.height / 2
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if tutorialMode {
            createAlert(titleNumber: 0, number: 0)
        }
    }
    
    func createAlert(titleNumber: Int, number: Int) {
        let alert = UIAlertController(title: alertTitle[titleNumber], message: alertMessage[number], preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Exit tutorial", style: UIAlertAction.Style.default, handler: {
            (action) in
            alert.dismiss(animated:true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Next tip", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            if number < self.numberOfMessages {
                self.createAlert(titleNumber: titleNumber + 1, number: number + 1)
            }
        }))
        self.present(alert, animated: true, completion: nil)
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
        var hitVector = SCNVector3Make(hitMat.m41, hitMat.m42, hitMat.m43)
        
        // Remove animations
        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            node.removeAllActions()
        }
        
        // When the hit test is not empty
        if !hitTest.isEmpty {
            let result = hitTest.first!
            let node = result.node
            selectedNode = node
            questionBranch = node.name ?? "AppIcon"
            
            // In Buiding mode
            if inBuidingMode{
                createObject(position: hitVector)
            }
                // In Quiz mode
            else if objectSet.contains(questionBranch) {
                
                // Rotate selected object
                if node.animationKeys.isEmpty {
                    let action = SCNAction.rotateBy(x: 0, y: 1, z: 0, duration: 1)
                    let forever = SCNAction.repeatForever(action)
                    node.runAction(forever)
                }
                
                //Add object's sound
                let sound = Bundle.main.path(forResource: sounds[questionBranch], ofType: "mp3")
                do {
                    audioplayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
                    print("added dog sound")
                } catch {
                    print("error playing sound")
                }
                // Show quiz
                if infoContainerView.isHidden == false {
                    quizContainerView.isHidden = true
                }
                quizViewController.generateQuestion()
                quizContainerView.isHidden = false
                
                infoViewController.generateFact()
                if infoContainerView.isHidden == false {
                    quizContainerView.isHidden = true
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
    @IBAction func quiz(_ sender: UIButton) {
        resetButton.isHidden = true
        quizButton.isHidden = true
        buildButton.isHidden = false
        itemView.isHidden = true
        inBuidingMode = false
        playSoundButton.isHidden = false
        stopSoundButton.isHidden = false
        infoButton.isHidden = false
        
        // COMMENT OUT LATER
        //quizContainerView.isHidden = false
    }
    
    // Goes into building mode
    @IBAction func build(_ sender: UIButton) {
        resetButton.isHidden = false
        quizButton.isHidden = false
        buildButton.isHidden = true
        itemView.isHidden = false
        
        hideQuizView()
        inBuidingMode = true
        playSoundButton.isHidden = true
        stopSoundButton.isHidden = true
        infoButton.isHidden = true
        infoContainerView.isHidden = true
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
    
    @IBAction func playSound(_ sender: UIButton) {
        print("playing sound")
        audioplayer.play()
    }
    @IBAction func stopSound(_ sender: UIButton) {
        print("stop playing sound")
        audioplayer.stop()
    }
    
    @IBAction func showObjectInfo(_ sender: UIButton) {
        if infoContainerView.isHidden == true {
            infoContainerView.isHidden = false
            quizContainerView.isHidden = true
            infoViewController.generateFact()
        } else if infoContainerView.isHidden == false {
            infoContainerView.isHidden = true
            quizContainerView.isHidden = false
        }
        infoContainerView.bringSubviewToFront(settingButton)
    }
    
    @IBAction func reset(_ sender: UIButton) {
        self.sceneView.session.pause()
        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
        self.sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    
    //MARK: Functions
    
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
        selectedNode.removeAllActions()
    }
    
}

