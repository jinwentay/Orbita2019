//
//  vehiclesViewController.swift
//  BuildAR
//
//  Created by Tay Jin Wen on 27/6/19.
//  Copyright © 2019 Tay Jin Wen. All rights reserved.
//

import UIKit

class vehiclesViewController: UIViewController {

    @IBOutlet weak var taxiButton: createWorldCustom!
    @IBOutlet weak var shipButton: createWorldCustom!
    
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

    @IBAction func ship(_ sender: UIButton) {
        objectScene = "art.scnassets/ship/ship.scn"
        objectNode = "spaceship"
        
        highlightButton(sender: sender)
    }
    
    @IBAction func helicopter(_ sender: UIButton) {
        objectScene = "art.scnassets/helicopter/helicopter.scn"
        objectNode = "helicopter"
        
        highlightButton(sender: sender)
    }
    
    @IBAction func taxi(_ sender: UIButton) {
        objectScene = "art.scnassets/taxi/taxi.scn"
        objectNode = "taxi"
        
        highlightButton(sender: sender)
    }
    
    @IBAction func train(_ sender: UIButton) {
        objectScene = "art.scnassets/train/train.scn"
        objectNode = "train"
        
        highlightButton(sender: sender)
    }
    
    func highlightButton(sender: UIButton) {
        selectedButton?.layer.borderColor = UIColor.white.cgColor
        sender.layer.borderColor = UIColor.blue.cgColor
        selectedButton = sender
    }
}
