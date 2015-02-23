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
    override func awakeFromNib() {
        super.awakeFromNib()
 
//        println("awakfrom nib \(self.post)")
        setUp()
    }
    override  init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        println("style \(self.post)")
    
    }
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//           println("coder \(self.post)")
       
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
    func setUp(){
        post.preferredMaxLayoutWidth = post.bounds.size.width
        handle.preferredMaxLayoutWidth = handle.bounds.size.width
        date.preferredMaxLayoutWidth = date.bounds.size.width
        
        
        post.sizeToFit()
        
        addBlur()
        
    }
    
    
    //MARK: Blur
    private func addBlur(){
        backgroundColor = UIColor.clearColor()
        let backgroundImageView = UIImageView()
        backgroundView = backgroundImageView
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = CGRectMake(0, 0, bounds.width, bounds.height)
        backgroundImageView.addSubview(blurView)
        
    }
}
