//
//  NavBarItem.swift
//  WeshApp
//
//  Created by rabzu on 25/03/2015.
//  Copyright (c) 2015 WeshApp. All rights reserved.
//

import UIKit

//Inherit from UIControl to add target actions stuff
public class NavBarItem: UIControl {

    var isPressed = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()

    }
    
    func setUp(){
        self.addTarget(self, action: "touchDown:", forControlEvents: .TouchDown)
        self.addTarget(self, action: "touchUpInside:", forControlEvents: .TouchUpInside)
        self.addTarget(self, action: "touchUpInside:", forControlEvents: .TouchUpOutside)
        self.backgroundColor = UIColor.clearColor()
    }
    
    
    
    func touchDown(sender: UIView) {
        isPressed = true
        setNeedsDisplay()
    }
    
    func touchUpInside(sender: UIView) {
        isPressed = false
        setNeedsDisplay()
    }

}
