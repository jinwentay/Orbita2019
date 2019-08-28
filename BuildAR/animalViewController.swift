//
//  animalViewController.swift
//  BuildAR
//
//  Created by Tay Jin Wen on 27/6/19.
//  Copyright © 2019 Tay Jin Wen. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

var selectedButton: UIButton?

class animalViewController: UIViewController {
    
    @IBOutlet weak var dogButton: createWorldCustom!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func dog(_ sender: UIButton) {
        objectScene = "art.scnassets/dog/dog.scn"
        objectNode = "dog"
        
        highlightButton(sender: sender)
    }
    
    @IBAction func cat(_ sender: UIButton) {
        objectScene = "art.scnassets/cat/cat.scn"
        objectNode = "cat"
        
        highlightButton(sender: sender)
    }
    
    @IBAction func zebra(_ sender: UIButton) {
        objectScene = "art.scnassets/zebra/zebra.scn"
        objectNode = "zebra"
        
        highlightButton(sender: sender)
    }
    
    @IBAction func lion(_ sender: UIButton) {
        objectScene = "art.scnassets/lion/lion.scn"
        objectNode = "lion"
        
        highlightButton(sender: sender)
    }
    
    @IBAction func poisonfrog(_ sender: UIButton) {
        objectScene = "art.scnassets/poisonfrog/PoisonDartFrog.scn"
        objectNode = "poisonfrog"
        
        highlightButton(sender: sender)
    }
    
    @IBAction func grasshopper(_ sender: UIButton) {
        objectScene = "art.scnassets/grasshopper/mantis.scn"
        objectNode = "mantis"
        
        highlightButton(sender: sender)
    }
    @IBAction func rooster(_ sender: UIButton) {
        objectScene = "art.scnassets/rooster/Rooster(1).scn"
        objectNode = "rooster"
        
        highlightButton(sender: sender)
    }
    func highlightButton(sender: UIButton) {
        selectedButton?.layer.borderColor = UIColor.white.cgColor
        sender.layer.borderColor = UIColor.darkGray.cgColor
        sender.layer.borderWidth = 2.0
        selectedButton = sender
    }
}
