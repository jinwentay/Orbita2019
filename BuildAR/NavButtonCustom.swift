//
//  NavButton.swift
//  BuildAR
//
//  Created by Deon Lee on 18/6/19.
//  Copyright © 2019 Tay Jin Wen. All rights reserved.
//

import UIKit

class NavButtonCustom: UIButton {
    
    override func didMoveToWindow() {
        if (self.currentTitle == "Reset") {
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowRadius = 2
            self.layer.cornerRadius = self.frame.height/2
            self.layer.shadowOpacity = 0.5
            self.layer.shadowOffset = CGSize(width: 2, height: 2)
            
        } else {
            self.layer.shadowColor = UIColor.black.cgColor
        }
        
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.7
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
    }

}
