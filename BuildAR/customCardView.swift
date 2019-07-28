//
//  customCardView.swift
//  BuildAR
//
//  Created by Jin Wen Tay on 29/7/19.
//  Copyright © 2019 Tay Jin Wen. All rights reserved.
//

import UIKit

class customCardView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func draw(_ rect: CGRect) {
        self.layer.borderWidth = 1.5
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 5).cgPath
    }

}
