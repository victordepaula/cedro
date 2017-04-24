//
//  Extension+UIImageView.swift
//  TravelWorld
//
//  Created by Victor de Paula on 22/04/17.
//  Copyright © 2017 Victor de Paula. All rights reserved.
//

import UIKit

extension UIImageView {
    func maskToCircle(){
        self.layer.frame = self.layer.frame.insetBy(dx: 0, dy: 0)
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.cornerRadius = self.frame.height/2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        self.layer.borderWidth = 0.5
        self.contentMode = .scaleAspectFill
    }
    
    func maskTo(_ corner: CGFloat) {
        self.layer.cornerRadius = corner
        self.layer.masksToBounds = true
    }
}

