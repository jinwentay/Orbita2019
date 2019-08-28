//
//  DYKViewController.swift
//  BuildAR
//
//  Created by Jin Wen Tay on 28/7/19.
//  Copyright © 2019 Tay Jin Wen. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
var infoViewController = DYKViewController()

class DYKViewController: UIViewController {
    @IBOutlet weak var DYKtitle: UILabel!
    @IBOutlet weak var objectImage: UIImageView!
    @IBOutlet weak var fact: UILabel!
    
    let roofRef = Database.database().reference()
    var images = ["dog": "dogbanner",
                  "spaceship": "shipbanner",
                  "taxi": "taxibanner",
                  "zebra":"zebrabanner",
                  "lion": "lionbanner",
                  "cat": "catbanner",
                  "train": "trainbanner",
                  "rooster": "roosterbanner",
                  "poisonfrog": "poisonfrogbanner",
                  "mantis":"mantisbanner"]
    override func viewDidLoad() {
        super.viewDidLoad()
        infoViewController = self
        
        let dataRef = roofRef.child("\(questionBranch)/info")
        dataRef.observe(.value) { (snap: DataSnapshot) in self.generateFact()
        }
        self.showImage(objectID: questionBranch)
        // Do any additional setup after loading the view.
    }
    
    //MARK: Functions
    public func generateFact() {
        let dataRef = roofRef.child("\(questionBranch)/info")
        dataRef.observe(.value) { (snap: DataSnapshot) in
            
            numberOfFacts = Int(snap.childrenCount)
            if numberOfFacts > 0 {
                factID = Int.random(in: 1...numberOfFacts)
            }
            //Set fact of object in DYK popup view
            self.setFactFromFirebase(label: self.fact)
        }
        self.showImage(objectID: questionBranch)
    }
    
    private func setFactFromFirebase(label: UILabel) {
        let ref = roofRef.child("\(questionBranch)/info/fact\(factID)")
        ref.observe(.value) { (snap: DataSnapshot) in
            label.text = snap.value as? String
        }
    }
    
    private func showImage(objectID: String) {
        let selectedImage = images[objectID]
        self.objectImage.image = UIImage(named: selectedImage ?? "Launch")
    }
}
