//
//  FlexibleNavBar.swift
//  WeshApp
//
//  Created by rabzu on 15/03/2015.
//  Copyright (c) 2015 WeshApp. All rights reserved.
//

import Foundation
import Designables
import BLKFlexibleHeightBar

//Required, to make objc code work with swift
extension BLKDelegateSplitter: UITableViewDelegate{
    
}

enum NavBarItem{
    case Burger
    case Cross
    case Plus
}


class FlexibleNavBar: BLKFlexibleHeightBar{
    private let statusBarHeight: CGFloat = 20.0
    private let leftItemXMargin: CGFloat = 0.05
   

    private let navBarProportionExpanded: CGFloat = 1.57
    private let navBarProportionCollapsed: CGFloat = 4.87
    
    private let navabarItemWidthfactor: CGFloat = 19.1025
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, handle: UILabel, name: UILabel? = nil, totem: UIImageView, rightItem: NavBarItem){
        self.init(frame: frame)
        let max  = self.frame.size.width / navBarProportionExpanded
        let min  = self.frame.size.width / navBarProportionCollapsed
        switch rightItem{
            case .Cross:
                self.configureProfileBar(max, min: min, handle: handle, name: name, totem: totem, leftItem: setUpBurger(), rightItem: setUpCross() )
            case .Plus:
                self.configureProfileBar(max, min: min, handle: handle, name: name, totem: totem, leftItem: setUpBurger(), rightItem: setUpPlus())
            default: break
        }
    }
    
    
    convenience init(frame: CGRect, centreItem: UIView?, rightItem: NavBarItem ){
        self.init(frame: frame)
        let max  = self.frame.size.width / navBarProportionCollapsed
        switch rightItem{
            case .Cross:
                self.configureBar(max, min: statusBarHeight, leftItem: setUpBurger(), centreItem: centreItem, rightItem: setUpCross() )
            case .Plus:
                self.configureBar(max, min: statusBarHeight, leftItem: setUpBurger(), centreItem: centreItem, rightItem: setUpPlus())
             default: break
        }
    }

    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpBurger() -> BurgerItem {
        //Menu Burger Item
        let burgerHeightToWidth: CGFloat = 21.91
        let burgerframe = CGRectMake(20, 20, self.frame.size.width / navabarItemWidthfactor,
            self.frame.size.width / burgerHeightToWidth)
        let burgerItem  = BurgerItem(frame: burgerframe)
        burgerItem.addTarget(self, action: "showMenu:", forControlEvents: .TouchUpInside)
        return burgerItem
    }
    
    private  func setUpCross() -> CrossItem{
        let crossFrame = CGRectMake(20, 20, self.frame.size.width / navabarItemWidthfactor,
                                self.frame.size.width / navabarItemWidthfactor)
        let crossItem = CrossItem(frame: crossFrame)
        crossItem.addTarget(self, action: "dismissPressed:", forControlEvents: .TouchUpInside)
        return crossItem
    }
    
    private  func setUpPlus() -> PlusItem{
        let plusFrame = CGRectMake(20, 20, self.frame.size.width / navabarItemWidthfactor,
                                            self.frame.size.width / navabarItemWidthfactor)
        let plusItem = PlusItem(frame: plusFrame)
        plusItem.addTarget(self, action: "handlePopover:", forControlEvents: .TouchUpInside)
        return plusItem
    }
   
    
    private func configureBar(max: CGFloat, min: CGFloat, leftItem: UIView?, centreItem: UIView? = nil, rightItem: UIView? = nil){
        
        self.maximumBarHeight = max
        self.minimumBarHeight = min
        self.clipsToBounds = true
        
        self.backgroundColor = UIColor(red: 0x51/255, green: 0xc1/255, blue: 0xd2/255, alpha: 1.0)
    
        if let segControl = centreItem{
            
            //segControl starting position: when bar is open
            var initialNameLabelLayoutAttributes = BLKFlexibleHeightBarSubviewLayoutAttributes()
            
            initialNameLabelLayoutAttributes.center = CGPointMake(self.bounds.width * 0.5, (max + statusBarHeight) * 0.5)
            initialNameLabelLayoutAttributes.size = segControl.sizeThatFits(CGSizeZero)
            segControl.addLayoutAttributes(initialNameLabelLayoutAttributes, forProgress: 0.0)
            //Final position: when bar is open
            var finalNameLabelLayoutAttributes = BLKFlexibleHeightBarSubviewLayoutAttributes(existingLayoutAttributes: initialNameLabelLayoutAttributes)
            finalNameLabelLayoutAttributes.center = CGPointMake(self.frame.size.width * 0.5, min * 0.25)
            finalNameLabelLayoutAttributes.alpha = 0.0
            segControl.addLayoutAttributes(finalNameLabelLayoutAttributes, forProgress: 1.0)
            
            self.addSubview(segControl)
        }
        
        if let item = leftItem{
            //STARTING
            var initialNameLabelLayoutAttributes = BLKFlexibleHeightBarSubviewLayoutAttributes()
            initialNameLabelLayoutAttributes.center = CGPointMake(self.bounds.width * leftItemXMargin, (max + statusBarHeight) * 0.5)
            initialNameLabelLayoutAttributes.size = item.sizeThatFits(CGSizeZero)
            item.addLayoutAttributes(initialNameLabelLayoutAttributes, forProgress: 0.0)
            var finalNameLabelLayoutAttributes = BLKFlexibleHeightBarSubviewLayoutAttributes(existingLayoutAttributes: initialNameLabelLayoutAttributes)
            //FINAL
            finalNameLabelLayoutAttributes.center = CGPointMake(self.frame.size.width * leftItemXMargin, min * 0.25)
            finalNameLabelLayoutAttributes.alpha = 0.0
            item.addLayoutAttributes(finalNameLabelLayoutAttributes, forProgress: 1.0)
            
            self.addSubview(item)
        }
        
        if let item = rightItem{
            //STARTING
            var initialNameLabelLayoutAttributes = BLKFlexibleHeightBarSubviewLayoutAttributes()
            
            initialNameLabelLayoutAttributes.center = CGPointMake( self.bounds.width - (self.bounds.width * leftItemXMargin), (
                                                                   max + statusBarHeight) * 0.5)
            initialNameLabelLayoutAttributes.size = item.sizeThatFits(CGSizeZero)
            item.addLayoutAttributes(initialNameLabelLayoutAttributes, forProgress: 0.0)
            //FINAL
            var finalNameLabelLayoutAttributes = BLKFlexibleHeightBarSubviewLayoutAttributes(existingLayoutAttributes: initialNameLabelLayoutAttributes)
            finalNameLabelLayoutAttributes.center = CGPointMake(self.bounds.width - (self.bounds.width * leftItemXMargin), self.minimumBarHeight * 0.25)
            finalNameLabelLayoutAttributes.alpha = 0.0
            item.addLayoutAttributes(finalNameLabelLayoutAttributes, forProgress: 1.0)
            
            self.addSubview(item)
            
        }
        
   
    }
    
    
    private func configureProfileBar(max: CGFloat, min: CGFloat, handle: UILabel, name: UILabel? = nil, totem: UIImageView, leftItem: UIView?, rightItem: UIView? = nil ){
        self.maximumBarHeight = max
        self.minimumBarHeight = min
        
         self.backgroundColor = UIColor(red: 0x51/255, green: 0xc1/255, blue: 0xd2/255, alpha: 1.0)
        
        //self.configureBar(min, min: min, leftItem: leftItem, centreItem: nil, rightItem: rightItem)
        
        if let item = leftItem{
            //STARTING
            var initialNameLabelLayoutAttributes = BLKFlexibleHeightBarSubviewLayoutAttributes()
            initialNameLabelLayoutAttributes.center = CGPointMake(self.bounds.width * leftItemXMargin, (min + statusBarHeight) * 0.5)
            initialNameLabelLayoutAttributes.size = item.sizeThatFits(CGSizeZero)
            item.addLayoutAttributes(initialNameLabelLayoutAttributes, forProgress: 0.0)
//            var finalNameLabelLayoutAttributes = BLKFlexibleHeightBarSubviewLayoutAttributes(existingLayoutAttributes: initialNameLabelLayoutAttributes)
             self.addSubview(item)
        }
        
        if let item = rightItem{
            //STARTING
            var initialNameLabelLayoutAttributes = BLKFlexibleHeightBarSubviewLayoutAttributes()
            
            initialNameLabelLayoutAttributes.center = CGPointMake( self.bounds.width - (self.bounds.width * leftItemXMargin), (
                                                                                        min + statusBarHeight) * 0.5)
            initialNameLabelLayoutAttributes.size = item.sizeThatFits(CGSizeZero)
            item.addLayoutAttributes(initialNameLabelLayoutAttributes, forProgress: 0.0)
          
            self.addSubview(item)
        }
        
        
        let imageProportion = CGFloat(5.07)
        totem.contentMode = UIViewContentMode.ScaleAspectFill
        
        
        //profileImageView.clipsToBounds = true
        //profileImageView.layer.cornerRadius = 35.0
//        profileImageView.layer.borderWidth = 0.0
//        profileImageView.layer.borderColor = UIColor.whiteColor().CGColor
        
        var initialProfileImageViewLayoutAttributes = BLKFlexibleHeightBarSubviewLayoutAttributes()
//        initialProfileImageViewLayoutAttributes.size = CGSizeMake(70.0, 70.0)
        initialProfileImageViewLayoutAttributes.size = CGSizeMake(self.frame.size.width / imageProportion, self.frame.size.width / imageProportion)

        initialProfileImageViewLayoutAttributes.center = CGPointMake(self.frame.size.width * 0.5, self.maximumBarHeight * 0.5)
        totem.addLayoutAttributes(initialProfileImageViewLayoutAttributes, forProgress: 0.0)
        
        var midwayProfileImageViewLayoutAttributes = BLKFlexibleHeightBarSubviewLayoutAttributes(existingLayoutAttributes: initialProfileImageViewLayoutAttributes)
        midwayProfileImageViewLayoutAttributes.center = CGPointMake(self.frame.size.width * 0.5, (self.maximumBarHeight - self.minimumBarHeight) * 0.8 + self.minimumBarHeight - 110.0)
        totem.addLayoutAttributes(midwayProfileImageViewLayoutAttributes, forProgress: 0.2)
        
        var finalProfileImageViewLayoutAttributes = BLKFlexibleHeightBarSubviewLayoutAttributes(existingLayoutAttributes: midwayProfileImageViewLayoutAttributes)
        
        finalProfileImageViewLayoutAttributes.center = CGPointMake(self.frame.size.width * 0.5, (self.maximumBarHeight - self.minimumBarHeight) * 0.64 + self.minimumBarHeight - 110.0)
        finalProfileImageViewLayoutAttributes.transform = CGAffineTransformMakeScale(0.5, 0.5)
        finalProfileImageViewLayoutAttributes.alpha = 0.0
        totem.addLayoutAttributes(finalProfileImageViewLayoutAttributes, forProgress: 0.5)
        
        self.addSubview(totem)
        
        let handleYFactor: CGFloat = 14.15
        handle.font = UIFont.systemFontOfSize(22.0)
        handle.textColor = UIColor.whiteColor()
        handle.sizeToFit()
//        nameLabel.text = name
    
        //Initial Expanded state
        var initialNameLabelLayoutAttributes = BLKFlexibleHeightBarSubviewLayoutAttributes()
        //                initialNameLabelLayoutAttributes.size = nameLabel.frame.size
        initialNameLabelLayoutAttributes.size = handle.sizeThatFits(CGSizeZero)
        initialNameLabelLayoutAttributes.center = CGPointMake(self.frame.size.width * 0.5, max - (self.frame.size.width / handleYFactor))
//            self.maximumBarHeight - 10.0
        
        handle.addLayoutAttributes(initialNameLabelLayoutAttributes, forProgress: 0.0)
        
        
        //Midway State
//        var midwayNameLabelLayoutAttributes = BLKFlexibleHeightBarSubviewLayoutAttributes(existingLayoutAttributes: initialNameLabelLayoutAttributes)
//        midwayNameLabelLayoutAttributes.center = CGPointMake(self.frame.size.width * 0.5,
//            
//            (self.maximumBarHeight - self.minimumBarHeight) * 0.4 + self.minimumBarHeight - 50.0)
//        midwayNameLabelLayoutAttributes
//        nameLabel.addLayoutAttributes(midwayNameLabelLayoutAttributes, forProgress: 0.6)
//        
        
        
        
        var finalNameLabelLayoutAttributes = BLKFlexibleHeightBarSubviewLayoutAttributes(existingLayoutAttributes: initialNameLabelLayoutAttributes)
        finalNameLabelLayoutAttributes.center = CGPointMake(self.frame.size.width * 0.5, (min + statusBarHeight) * 0.5)
        //finalNameLabelLayoutAttributes.transform = CGAffineTransformMakeScale(0.5, 0.5)
        //finalNameLabelLayoutAttributes.alpha = 0.0
        handle.addLayoutAttributes(finalNameLabelLayoutAttributes, forProgress: 1.0)
        self.addSubview(handle)
        
        
        if let n = name{
            
            
            
        
        
        n.font = UIFont.systemFontOfSize(22.0)
        n.textColor = UIColor.whiteColor()
        n.sizeToFit()
        
        //Initial Expanded state
        var initialNameLabelLayoutAttributes = BLKFlexibleHeightBarSubviewLayoutAttributes()
        //                initialNameLabelLayoutAttributes.size = nameLabel.frame.size
        initialNameLabelLayoutAttributes.size = n.sizeThatFits(CGSizeZero)
        initialNameLabelLayoutAttributes.center = CGPointMake(self.frame.size.width * 0.5, (min + statusBarHeight) * 0.5)
        //            self.maximumBarHeight - 10.0
        
        n.addLayoutAttributes(initialNameLabelLayoutAttributes, forProgress: 0.0)
        
        
        //Midway State
                var midwayNameLabelLayoutAttributes = BLKFlexibleHeightBarSubviewLayoutAttributes(existingLayoutAttributes: initialNameLabelLayoutAttributes)
                midwayNameLabelLayoutAttributes.center = CGPointMake(self.frame.size.width * 0.5, (min + statusBarHeight) * 0.5)
                midwayNameLabelLayoutAttributes.alpha = 0.6
                n.addLayoutAttributes(midwayNameLabelLayoutAttributes, forProgress: 0.6)
        
        
        
        
        var finalNameLabelLayoutAttributes = BLKFlexibleHeightBarSubviewLayoutAttributes(existingLayoutAttributes: initialNameLabelLayoutAttributes)
        finalNameLabelLayoutAttributes.center = CGPointMake(self.frame.size.width * 0.5, (min + statusBarHeight) * 0.5)
        //        finalNameLabelLayoutAttributes.transform = CGAffineTransformMakeScale(0.5, 0.5)
                finalNameLabelLayoutAttributes.alpha = 0.0
        n.addLayoutAttributes(finalNameLabelLayoutAttributes, forProgress: 1.0)
        
          
            
        self.addSubview(n)
        }
    }
    
    
    
    
    //MARK: menu
    func showMenu(sender: UIView) {
        NSNotificationCenter.defaultCenter().postNotificationName("ShowMenu", object: self)
    }
    func dismissPressed(sender: UIView){
        NSNotificationCenter.defaultCenter().postNotificationName("SegueBack", object: self)
    }
    func handlePopover(sender: UIView){
        NSNotificationCenter.defaultCenter().postNotificationName("DoPopover", object: self)
    }
    
}