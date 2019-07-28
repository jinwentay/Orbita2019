//
//  settingButtons.swift
//  BuildAR
//
//  Created by Jin Wen Tay on 28/7/19.
//  Copyright © 2019 Tay Jin Wen. All rights reserved.
//

import UIKit

class settingButtons: UIButton {

    override func awakeFromNib() {//allows us to provide custom functionalities to button
        super.awakeFromNib()
        customizeButtons()
    }
    
    func customizeButtons(){
        //        backgroundColor = UIColor.lightGray
        layer.cornerRadius = 10.0
        layer.borderWidth = 2.0
        layer.borderColor = UIColor.white.cgColor
        backgroundColor = UIColor.cyan
    }
}
