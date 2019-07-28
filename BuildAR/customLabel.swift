//
//  customLabel.swift
//  BuildAR
//
//  Created by Jin Wen Tay on 28/7/19.
//  Copyright © 2019 Tay Jin Wen. All rights reserved.
//

import UIKit

class customLabel: UILabel {

    override func awakeFromNib() {//allows us to provide custom functionalities to button
        super.awakeFromNib()
        customizeLabels()
    }
    
    func customizeLabels(){
        backgroundColor = UIColor.init(red: 1, green: 0.952, blue: 0.341, alpha: 1)
        layer.cornerRadius = 5.0
        layer.borderWidth = 2.0
        layer.borderColor = UIColor.lightGray.cgColor
    }
}
