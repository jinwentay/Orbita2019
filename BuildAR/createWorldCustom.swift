//
//  createWorldCustom.swift
//  BuildAR
//
//  Created by Tay Jin Wen on 5/6/19.
//  Copyright © 2019 Tay Jin Wen. All rights reserved.
//

import UIKit

class createWorldCustom: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {//allows us to provide custom functionalities to button
        super.awakeFromNib()
        customizeButtons()
    }
    
    func customizeButtons(){
//        backgroundColor = UIColor.lightGray
        setTitleColor(UIColor.white, for: .normal)
        layer.cornerRadius = 10.0
        layer.borderWidth = 2.0
        layer.borderColor = UIColor.white.cgColor
    }
}
