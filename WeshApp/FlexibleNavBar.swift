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

extension BLKDelegateSplitter: UITableViewDelegate{
    
}


class FlexibleNavBar: BLKFlexibleHeightBar{
    private let statusBarHeight: CGFloat = 20.0
    private let leftItemXMargin: CGFloat = 0.05
  
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, max: CGFloat, min: CGFloat, handle: String, name: String){
        self.init(frame: frame)
        self.configureProfileBar(max, min: min, handle: handle, name: name)
    }
    
    convenience init(frame: CGRect, max: CGFloat, min: CGFloat, leftItem: UIView?, centreItem: UIView?, rightItem: UIView?){
        self.init(frame: frame)
        self.configureBar(max, min: min, leftItem: leftItem, centreItem: centreItem, rightItem: rightItem)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
    private func configureBar(max: CGFloat, min: CGFloat, leftItem: UIView?, centreItem: UIView?, rightItem: UIView? = nil){
        
    
        self.maximumBarHeight = max
        self.minimumBarHeight = min
        self.clipsToBounds = true
        
        self.backgroundColor = UIColor(red: 0x51/255, green: 0xc1/255, blue: 0xd2/255, alpha: 1.0)
    
        if let segControl = centreItem?{
            
            //segControl starting position: when bar is open
            var initialNameLabelLayoutAttributes = BLKFlexibleHeightBarSubviewLayoutAttributes()
            
            initialNameLabelLayoutAttributes.center = CGPointMake(self.bounds.width * 0.5, (maximumBarHeight + statusBarHeight) * 0.5)
            initialNameLabelLayoutAttributes.size = segControl.sizeThatFits(CGSizeZero)
            segControl.addLayoutAttributes(initialNameLabelLayoutAttributes, forProgress: 0.0)
            //Final position: when bar is open
            var finalNameLabelLayoutAttributes = BLKFlexibleHeightBarSubviewLayoutAttributes(existingLayoutAttributes: initialNameLabelLayoutAttributes)
            finalNameLabelLayoutAttributes.center = CGPointMake(self.frame.size.width * 0.5, self.minimumBarHeight * 0.25)
            finalNameLabelLayoutAttributes.alpha = 0.0
            segControl.addLayoutAttributes(finalNameLabelLayoutAttributes, forProgress: 1.0)
            
            self.addSubview(segControl)
        }
        
        if let item = leftItem?{
            //STARTING
            var initialNameLabelLayoutAttributes = BLKFlexibleHeightBarSubviewLayoutAttributes()
            initialNameLabelLayoutAttributes.center = CGPointMake(self.bounds.width * leftItemXMargin, (maximumBarHeight + statusBarHeight) * 0.5)
            initialNameLabelLayoutAttributes.size = item.sizeThatFits(CGSizeZero)
            item.addLayoutAttributes(initialNameLabelLayoutAttributes, forProgress: 0.0)
            var finalNameLabelLayoutAttributes = BLKFlexibleHeightBarSubviewLayoutAttributes(existingLayoutAttributes: initialNameLabelLayoutAttributes)
            //FINAL
            finalNameLabelLayoutAttributes.center = CGPointMake(self.frame.size.width * leftItemXMargin, self.minimumBarHeight * 0.25)
            finalNameLabelLayoutAttributes.alpha = 0.0
            item.addLayoutAttributes(finalNameLabelLayoutAttributes, forProgress: 1.0)
            
            self.addSubview(item)
        }
        
        if let item = rightItem?{
            //STARTING
            var initialNameLabelLayoutAttributes = BLKFlexibleHeightBarSubviewLayoutAttributes()
            
            initialNameLabelLayoutAttributes.center = CGPointMake( self.bounds.width - (self.bounds.width * leftItemXMargin), (
                                                                   maximumBarHeight + statusBarHeight) * 0.5)
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
    
    
    private func configureProfileBar(max: CGFloat, min: CGFloat, handle: String, name: String){
        
        let navBarProportionExpanded = CGFloat(1.57)
        let navBarProportionCollapsed = CGFloat(4.87)
        let imageProportion = CGFloat(5.07)
        
        self.maximumBarHeight = self.frame.size.width / navBarProportionExpanded
        self.minimumBarHeight = self.frame.size.width / navBarProportionCollapsed

        
        
        self.backgroundColor = UIColor(red: 0x51/255, green: 0xc1/255, blue: 0xd2/255, alpha: 1.0)
       
      
       
        //Profile Image
        var profileImageView = UIImageView(image: UIImage(named: "Lion"))
        profileImageView.contentMode = UIViewContentMode.ScaleAspectFill
        //profileImageView.clipsToBounds = true
        //profileImageView.layer.cornerRadius = 35.0
//        profileImageView.layer.borderWidth = 0.0
//        profileImageView.layer.borderColor = UIColor.whiteColor().CGColor
        
        var initialProfileImageViewLayoutAttributes = BLKFlexibleHeightBarSubviewLayoutAttributes()
//        initialProfileImageViewLayoutAttributes.size = CGSizeMake(70.0, 70.0)
        initialProfileImageViewLayoutAttributes.size = CGSizeMake(self.frame.size.width / imageProportion, self.frame.size.width / imageProportion)

        initialProfileImageViewLayoutAttributes.center = CGPointMake(self.frame.size.width * 0.5, self.maximumBarHeight * 0.5)
        profileImageView.addLayoutAttributes(initialProfileImageViewLayoutAttributes, forProgress: 0.0)
        
        var midwayProfileImageViewLayoutAttributes = BLKFlexibleHeightBarSubviewLayoutAttributes(existingLayoutAttributes: initialProfileImageViewLayoutAttributes)
        midwayProfileImageViewLayoutAttributes.center = CGPointMake(self.frame.size.width * 0.5, (self.maximumBarHeight - self.minimumBarHeight) * 0.8 + self.minimumBarHeight - 110.0)
        profileImageView.addLayoutAttributes(midwayProfileImageViewLayoutAttributes, forProgress: 0.2)
        
        var finalProfileImageViewLayoutAttributes = BLKFlexibleHeightBarSubviewLayoutAttributes(existingLayoutAttributes: midwayProfileImageViewLayoutAttributes)
        
        finalProfileImageViewLayoutAttributes.center = CGPointMake(self.frame.size.width * 0.5, (self.maximumBarHeight - self.minimumBarHeight) * 0.64 + self.minimumBarHeight - 110.0)
        finalProfileImageViewLayoutAttributes.transform = CGAffineTransformMakeScale(0.5, 0.5)
        finalProfileImageViewLayoutAttributes.alpha = 0.0
        profileImageView.addLayoutAttributes(finalProfileImageViewLayoutAttributes, forProgress: 0.5)
        
        self.addSubview(profileImageView)
        
        
        
        
        
        
        var nameLabel = UILabel()
        nameLabel.font = UIFont.systemFontOfSize(22.0)
        nameLabel.textColor = UIColor.whiteColor()
        nameLabel.sizeToFit()
        nameLabel.text = name
    
        var initialNameLabelLayoutAttributes = BLKFlexibleHeightBarSubviewLayoutAttributes()
        //                initialNameLabelLayoutAttributes.size = nameLabel.frame.size
        initialNameLabelLayoutAttributes.size = nameLabel.sizeThatFits(CGSizeZero)
        initialNameLabelLayoutAttributes.center = CGPointMake(self.frame.size.width * 0.5, self.maximumBarHeight - 50.0)
        
        nameLabel.addLayoutAttributes(initialNameLabelLayoutAttributes, forProgress: 0.0)
        
        
        
        var midwayNameLabelLayoutAttributes = BLKFlexibleHeightBarSubviewLayoutAttributes(existingLayoutAttributes: initialNameLabelLayoutAttributes)
        midwayNameLabelLayoutAttributes.center = CGPointMake(self.frame.size.width * 0.5, (self.maximumBarHeight - self.minimumBarHeight) * 0.4 + self.minimumBarHeight - 50.0)
        nameLabel.addLayoutAttributes(midwayNameLabelLayoutAttributes, forProgress: 0.6)
        
        var finalNameLabelLayoutAttributes = BLKFlexibleHeightBarSubviewLayoutAttributes(existingLayoutAttributes: midwayNameLabelLayoutAttributes)
        finalNameLabelLayoutAttributes.center = CGPointMake(self.frame.size.width * 0.5, self.minimumBarHeight - 25.0)
        //        finalNameLabelLayoutAttributes.transform = CGAffineTransformMakeScale(0.5, 0.5)
        //        finalNameLabelLayoutAttributes.alpha = 0.0
        nameLabel.addLayoutAttributes(finalNameLabelLayoutAttributes, forProgress: 1.0)
        
        self.addSubview(nameLabel)
    
    
    }
    
    
}