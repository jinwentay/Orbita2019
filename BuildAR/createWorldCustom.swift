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
//        backgroundColor = UIColor.blue
        setTitleColor(UIColor.white, for: .normal)
        layer.cornerRadius = 10.0
        layer.borderWidth = 2.0
        layer.borderColor = UIColor.white.cgColor
    }
    
    func pulsate() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.4
        pulse.fromValue = 0.98
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = .infinity
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        layer.add(pulse, forKey: nil)
    }
}
