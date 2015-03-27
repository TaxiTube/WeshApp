//
//  WallPostTableViewCell.swift
//  WeshApp
//
//  Created by rabzu on 25/12/2014.
//  Copyright (c) 2014 WeshApp. All rights reserved.
//

import UIKit

class WallPostTableViewCell: UITableViewCell {

    @IBOutlet weak var handle: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var totem: UIImageView!
    @IBOutlet weak var post: UILabel!
    

    //MARK: Initialisation
    //This method is called on every single object that is unarchived from a nib file,
    //after all outlets/actions have been set up. If initWithCoder:
    //is the beginning of the nib unarchiving process, then awakeFromNib is the end.
    //It signals to the object that all objects have been unarchived and that all
    //of its connections are available
    override func awakeFromNib() {
        super.awakeFromNib()
 
//        println("awakfrom nib \(self.post)")
        setUp()
    }
    override  init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

    
    }
    
    //This method is the initializer for all archived objects.
    //As objects stored in nibs are archived objects, this is
    //the initializer used when loading an object from a nib.
    //At the time it's called, the object is being deserialized from the nib,
    //but outlets/actions are not yet hooked up.
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
    func setUp(){
        post.preferredMaxLayoutWidth = post.bounds.size.width
        handle.preferredMaxLayoutWidth = handle.bounds.size.width
        date.preferredMaxLayoutWidth = date.bounds.size.width
        
        
       // post.sizeToFit()
        
      //  addBlur()
        
    }
    
    
    //MARK: Blur
//    private func addBlur(){
//        backgroundColor = UIColor.clearColor()
//        let backgroundImageView = UIImageView()
//        backgroundView = backgroundImageView
//        
//        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
//        let blurView = UIVisualEffectView(effect: blurEffect)
//        blurView.frame = CGRectMake(0, 0, bounds.width, bounds.height)
//        backgroundImageView.addSubview(blurView)
//        
//    }
}
