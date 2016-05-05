//
//  CustomSKView.swift
//  FreezingDay
//
//  Created by Mac on 10/13/15.
//  Copyright © 2015 clement siess. All rights reserved.
//

import SpriteKit

class CustomSKView: SKView {
    
    var stayPaused = false as Bool
    
    override var paused: Bool {
        get {
            return super.paused
        }
        set {
            if (!stayPaused) {
                super.paused = newValue
            }
            stayPaused = false
        }
    }
    
    func setStayPaused() {
        self.stayPaused = true
    }
}