//
//  questionCustomLabel.swift
//  BuildAR
//
//  Created by Tay Jin Wen on 29/6/19.
//  Copyright © 2019 Tay Jin Wen. All rights reserved.
//

import UIKit

class questionCustomLabel: UILabel {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func draw(_ rect: CGRect) {
        self.textColor = UIColor.black
        self.layer.cornerRadius = 5.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.black.cgColor
    }
    
}
