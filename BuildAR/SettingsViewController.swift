//
//  SettingsViewController.swift
//  BuildAR
//
//  Created by Deon Lee on 16/7/19.
//  Copyright © 2019 Tay Jin Wen. All rights reserved.
//
import UIKit
import SceneKit
import ARKit
import Firebase

var inARMode = true
var questionLevel = "standard"
var tutorialMode = true

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var modeSegment: UISegmentedControl!
    @IBOutlet weak var levelSegment: UISegmentedControl!
    @IBOutlet weak var tutorialSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if inARMode {
            mainViewController.reset(mainViewController.resetButton)
        }
        setupSegments()
    }
    
    func setupSegments() {
        if questionLevel == "standard" {
            levelSegment.selectedSegmentIndex = 0
        } else {
            levelSegment.selectedSegmentIndex = 1
        }
        if inARMode {
            print("AR mode")
            modeSegment.selectedSegmentIndex = 0
        } else {
            print("Virtual mode")
            modeSegment.selectedSegmentIndex = 1
        }
        if tutorialMode {
            tutorialSwitch.isOn = true
        } else {
            tutorialSwitch.isOn = false
        }
    }
    
    // MARK: Actions
    @IBAction func back(_ sender: UIButton) {
        if inARMode {
            performSegue(withIdentifier: "backToAR", sender: self)
        } else {
            performSegue(withIdentifier: "backToScene", sender: self)
        }
    }
    @IBAction func switchMode(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            inARMode = true
            performSegue(withIdentifier: "backToAR", sender: self)
        } else {
            inARMode = false
            performSegue(withIdentifier: "backToScene", sender: self)
        }
    }
    @IBAction func switchLevel(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            questionLevel = "standard"
        } else {
            questionLevel = "advanced"
        }
    }
    @IBAction func switchTutorial(_ sender: UISwitch) {
        if sender.isOn {
            tutorialMode = true
        } else {
            tutorialMode = false
        }
    }
}
