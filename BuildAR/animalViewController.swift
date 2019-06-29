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
        objectScene = "art.scnassets/beagle/Mesh_Beagle.scn"
        objectNode = "animal"
    }
    
}
