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
    
    var sceneView:SCNView!
    var scene:SCNScene!
    
    
    override func viewDidLoad() {
        setupScene()
    }
    
    func setupScene(){
        sceneView = (self.view as! SCNView)
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
        scene = SCNScene(named: "art.scnassets/SceneKit/mainScene.scn")
        sceneView.scene = scene
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
    
}
