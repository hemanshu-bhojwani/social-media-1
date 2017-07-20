//
//  CircleView2.swift
//  social-media-1
//
//  Created by Gopal Bhojwani on 7/10/17.
//  Copyright © 2017 Hemanshu Bhojwani. All rights reserved.
//

import UIKit

class CircleView2: UIImageView {
    
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }
    
    
}

/*
 // Only override draw() if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 override func draw(_ rect: CGRect) {
 // Drawing code
 }
 */

