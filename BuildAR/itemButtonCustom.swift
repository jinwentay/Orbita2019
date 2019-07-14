//
//  itemButtonCustom.swift
//  BuildAR
//
//  Created by Deon Lee on 13/7/19.
//  Copyright © 2019 Tay Jin Wen. All rights reserved.
//

import UIKit

class itemButtonCustom: UIButton {
    
    var pressed = false

    override func didMoveToWindow() {
        
        pressed = !pressed
        
        if pressed {
            self.layer.borderColor = UIColor.red.cgColor
            self.layer.borderWidth = 1
        }
    }

}
