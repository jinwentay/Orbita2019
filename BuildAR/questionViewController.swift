//
//  questionViewController.swift
//  BuildAR
//
//  Created by Deon Lee on 9/7/19.
//  Copyright © 2019 Tay Jin Wen. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class questionViewController: UIViewController {

    @IBOutlet weak var questionImage: UIImageView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var labelA: UILabel!
    @IBOutlet weak var labelB: UILabel!
    @IBOutlet weak var labelC: UILabel!
    @IBOutlet weak var labelD: UILabel!
    @IBOutlet weak var backButton: NavButtonCustom!
    @IBOutlet weak var nextButton: NavButtonCustom!
    @IBOutlet weak var resultImage: UIImageView!
    @IBOutlet weak var choiceView: UIStackView!
    @IBOutlet var quizView: UIView!
    
    let roofRef = Database.database().reference()
    
    var currentButton: UIButton? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Comment out later
        
        let dataRef = roofRef.child("\(questionBranch)")
        dataRef.observe(.value) { (snap: DataSnapshot) in
            
            numberOfQuestions = Int(snap.childrenCount)
            self.generateQuestion()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK: Actions
    
    @IBAction func choice(_ sender: UIButton) {
        
        print("Button pressed is " + sender.currentTitle!)
        
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
        quizView.isHidden = true
        
        // Reset the question view
        next(nextButton)
    }

    
    // MARK: Functions
    
    //set object image when object is tapped for quiz section
    private func generateImage(objectID: String) {
        let selectedImage = images[objectID]
        self.questionImage.image = UIImage(named: selectedImage ?? "AppIcon")
    }
    
    private func generateQuestion() {
        
        // Get a new question
        questionID = Int.random(in: 1...numberOfQuestions)
        
        // Set text for question label and for each choice label
        labelTextFromFirebase(key: "question", label: self.questionLabel)
        labelTextFromFirebase(key: "choiceA", label: self.labelA)
        labelTextFromFirebase(key: "choiceB", label: self.labelB)
        labelTextFromFirebase(key: "choiceC", label: self.labelC)
        labelTextFromFirebase(key: "choiceD", label: self.labelD)
    }
    
    private func labelTextFromFirebase(key: String, label: UILabel) {
        
        // Retrieve text from Firebase
        let referance = roofRef.child("\(questionBranch)/qn\(questionID)/\(key)")
        referance.observe(.value) { (snap: DataSnapshot) in
            label.text = snap.value as? String
        }
    }
    
    private func checkAnswer(choice: String) {
        
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
}
