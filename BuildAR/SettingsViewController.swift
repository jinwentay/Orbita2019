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
var questionLevel = ""

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var changeToSceneButton: UIButton!
    @IBOutlet weak var changeToARButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeToARButton.isHidden = inARMode
        changeToSceneButton.isHidden = !inARMode
    }
    
    // MARK: Actions
    @IBAction func back(_ sender: UIButton) {
        if inARMode {
            performSegue(withIdentifier: "backToAR", sender: self)
        } else {
            performSegue(withIdentifier: "backToScene", sender: self)
        }
    }
    @IBAction func switchToScene(_ sender: UIButton) {
        inARMode = false
        changeToSceneButton.isHidden = true
        changeToARButton.isHidden = false
        performSegue(withIdentifier: "backToScene", sender: self)
    }
    @IBAction func switchToAR(_ sender: UIButton) {
        inARMode = true
        changeToSceneButton.isHidden = false
        changeToARButton.isHidden = true
        performSegue(withIdentifier: "backToAR", sender: self)
    }
    @IBAction func switchLevel(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            questionLevel = "standard"
        } else {
            questionLevel = "advanced"
        }
    }
}
