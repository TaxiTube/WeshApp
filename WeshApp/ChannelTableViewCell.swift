//
//  ChannelTableViewCell.swift
//  WeshApp
//
//  Created by rabzu on 05/02/2015.
//  Copyright (c) 2015 WeshApp. All rights reserved.
//

import UIKit
import Designables

//MARK: Protocol
protocol ChannetlTableViewCellDelegate{
        func pauseAction()
        func cellDidOpen(cell: ChannelTableViewCell)
        func cellDidClose(cell: ChannelTableViewCell)
}

class ChannelTableViewCell: UITableViewCell {
    
    private let kBounceValue: CGFloat = 20.0
    //MARK: Outlets
    @IBOutlet weak var leftView: UIView?
    
    @IBOutlet weak var counter: UILabel!
    @IBOutlet weak var elementContainer: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var totem: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subTitle: UILabel!

    @IBOutlet weak var contentViewRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewLeftConstraint: NSLayoutConstraint!
    
    //MARK properties
    var  delegate: ChannetlTableViewCellDelegate?
    private var panRecognizer: UIPanGestureRecognizer?
    private var panStartPoint: CGPoint?
    private var startingRightConstant: CGFloat?
    
    
    
    var isClosed:Bool?

    
    //MARK: Initialisation
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpPan()
       
        
    }
    
    override  init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpPan()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
      //  setUpPan()

    }
    
    private func setUpPan(){
        self.isClosed = true
        self.layer.backgroundColor = UIColor.whiteColor().CGColor
        panRecognizer = UIPanGestureRecognizer(target: self, action: "panThisCell:")
        panRecognizer!.delegate = self
        addGestureRecognizer(panRecognizer!)
    }

    
   //MARK: Handle Pan Gesures
    func panThisCell(pan: UIPanGestureRecognizer){
        
        switch pan.state{
            case .Began:
                // store the initial position of the cell (i.e. the constraint value), to determine whether the cell is opening or closing.
                panStartPoint = pan.translationInView(contentView)
                startingRightConstant = contentViewRightConstraint.constant
            case .Changed:
                handlePanChange(pan)
            case .Ended:
                handePanEnded(pan)
                break
            case .Cancelled:
                
                if startingRightConstant == 0 {
                    //Cell was closed - reset everything to 0
                    resetConstraintToZero(true, notifyDelegate: true)
                } else {
                    setConstraintToShowAllButtons(true, notifyDelegate: true)
                }

                break
            default:
                break
            }
    }
    //Handle Change in Pan gesture
    private func handlePanChange(pan: UIPanGestureRecognizer){
        var currentPoint = pan.translationInView(contentView)
        var deltaX = currentPoint.x - panStartPoint!.x
        var panningLeft = false
        //1. determin if swiping is to the left/right
        if currentPoint.x < panStartPoint!.x{
            panningLeft = true
        }
        
        //The cell was closed and is now opening
        if self.startingRightConstant == 0 {
            if(!panningLeft){ //2.
                //Swipe from left to right to close the cell when finger is not lifted
                //left to right swipe results positiv value
                var constant = max(-deltaX, 0)
                if constant == 0 { //4. if constant is zero handle cell closing
                    resetConstraintToZero(true, notifyDelegate: true)
                }else{ // 5. if not zero then set right hand side constraint
                    contentViewRightConstraint.constant = constant
                }
            } else{
                //otherwise if panning is from right to left, user is opening the cell.
                var constant = min(-deltaX, buttonTotalWidth())
                if constant == buttonTotalWidth(){
                        setConstraintToShowAllButtons(true, notifyDelegate: false)
                } else{ //if constant is not the total width pause button set the constant to the right constrait's constant
                    contentViewRightConstraint.constant = constant
                }
            }
            
        } else {  // the cell was at least partially open
            // 1. how much ajdustment has been made
            var adjustment = startingRightConstant! - deltaX
            if !panningLeft {
                //2.If the user is panning left to right, you must take the greater of the adjustment or 0.
                // If the adjustment has veered into negative numbers, that means the user has swiped beyond the edge of the cell, and the cell is closed
                var constant = max(adjustment, 0)
                //3. cell is closed
                if(constant == 0){
                    resetConstraintToZero(true, notifyDelegate: false)
                } else {
                    contentViewRightConstraint.constant = constant
                }
            } else{
                //5.Panning right to left: If the adjustment is higher, then the user has swiped too far past the catch point.
                var constant = min(adjustment, buttonTotalWidth())
                //6. the cell is open; handle opening the cell.
                if constant == self.buttonTotalWidth(){
                    setConstraintToShowAllButtons(true, notifyDelegate: false)
                } else {
                    contentViewRightConstraint.constant = constant
                }
            }
        }
        
        //8. set the left cell
        contentViewLeftConstraint.constant = -contentViewRightConstraint.constant
    }
    //Handle Pan Gesture ending
    private func handePanEnded(pan: UIPanGestureRecognizer){
        //1.Check whether the cell was laready open
        if startingRightConstant == 0 {
            //Cell was opening
            //2.if the cell was closed and its being open
            var halfrightView = CGRectGetWidth(rightView.frame) / 2
            //3. if cell has been opend more than the half oway of the pause view then open
            if contentViewRightConstraint.constant >= halfrightView{
                //open all the way
                    setConstraintToShowAllButtons(true, notifyDelegate: true)
            } else{
                //if cell is not being open more than half oway of the view then re-close
                resetConstraintToZero(true, notifyDelegate: true)
            }
        } else {
            var buttonOnePlusHalfOfButton2 :CGFloat = 0.0
            //Cell was closing
            if let leftViewFrame = leftView?.frame{
                  buttonOnePlusHalfOfButton2 = CGRectGetWidth(rightView.frame) + CGRectGetWidth(leftViewFrame) / 2
            } else{
                
                 buttonOnePlusHalfOfButton2 = CGRectGetWidth(rightView.frame) / 2
            }
          
            if contentViewRightConstraint.constant >= buttonOnePlusHalfOfButton2{
                //Re-open all the way
                setConstraintToShowAllButtons(true, notifyDelegate: true)
            } else {
                resetConstraintToZero(true, notifyDelegate: true)
            }
        }

    }
    
    //how far should the cell slide
   private  func buttonTotalWidth()->CGFloat{
    
        if let leftViewFrame = leftView?.frame{
            return CGRectGetWidth(frame) - CGRectGetMinX(leftViewFrame)
        } else{
        
        return CGRectGetWidth(frame) - CGRectGetMinX(rightView.frame)
        }
    
    }
    
    //MARK: Constraint handling
    //Close the cell
   private  func resetConstraintToZero(animated: Bool, notifyDelegate: Bool){
        self.isClosed = true

        //Delegate
        if (notifyDelegate) {
            delegate!.cellDidClose(self)
        }
        
        //1 If the cell started open and the constraint is already at the full open value, just bail
        if(startingRightConstant == 0 && contentViewRightConstraint.constant == 0){
            //Already closed, no bounce needed
            return
        }
        
        //2
        self.contentViewRightConstraint.constant = -kBounceValue
        self.contentViewLeftConstraint.constant = kBounceValue
        
        
        var completion =  { (value: Bool) -> () in
            
            self.contentViewLeftConstraint.constant = 0
            self.contentViewRightConstraint.constant = 0
            
            var comp = { (value2: Bool) -> () in
                //4.
                self.startingRightConstant = self.contentViewRightConstraint.constant
            }
            
            self.updateConstraintsIfNeeded(true, completion: comp)
            
        }
         self.updateConstraintsIfNeeded(true, completion: completion)

    }
    
    //Open the cell
   private func setConstraintToShowAllButtons(animated: Bool, notifyDelegate: Bool){
        self.isClosed = false
        //Delegate
        if (notifyDelegate) {
            delegate?.cellDidOpen(self)
        }

        //1. If the cell started open and the constraint is already at the full open value, just bail
        if !(startingRightConstant == buttonTotalWidth() && contentViewRightConstraint.constant == buttonTotalWidth()) {
            //2
            contentViewLeftConstraint.constant = -buttonTotalWidth() - kBounceValue
            contentViewRightConstraint.constant = buttonTotalWidth() + kBounceValue
        
            self.updateConstraintsIfNeeded(true, completion: { (value: Bool) -> () in
                
                self.contentViewLeftConstraint.constant = -self.buttonTotalWidth()
                self.contentViewRightConstraint.constant = self.buttonTotalWidth()
             
                
                self.updateConstraintsIfNeeded(true, completion:  { (value2: Bool) -> () in
                    //4.
                    self.startingRightConstant = self.contentViewRightConstraint.constant
                })
                
                }
                
            )
        }
    }
    //Animation method
   private func updateConstraintsIfNeeded(animated: Bool, completion:  Bool->()) {

        var duration = 0.0
        if animated { duration = 0.1 }
        var animations = { ()  in
            self.layoutIfNeeded()
        }
        
        UIView.animateWithDuration(duration, delay: 0,
                                           options: UIViewAnimationOptions.CurveEaseOut,
                                        animations: animations,
                                        completion: completion)
    }
    
    
    func openCell(){
        setConstraintToShowAllButtons(true, notifyDelegate: false)
    }
    func closeCell(){
        resetConstraintToZero(true, notifyDelegate: false)
    }
    
    //MARK: UIGestureRecogniserDelegate
    //First, your UIPanGestureRecognizer can sometimes interfere with the one which handles the scroll action on the UITableView
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translationInView(superview!)
            if fabs(translation.x) > fabs(translation.y)  {
                return true
            }
            return false
        }
        return false
    }
    //MARK: Reuse methods
    override func prepareForReuse() {
        super.prepareForReuse()
        resetConstraintToZero(false, notifyDelegate: false)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
//        if(selected) {
//            backgroundColor = UIColor.grayColor()
//        }
    }
    
    
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        if(highlighted) {
    
            backgroundColor = UIColor.whiteColor()
        }
    }
   /*
    override func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return true
    }
    */
    func highlightCell(active: Bool){
        if active {
            self.elementContainer.backgroundColor = UIColor(red: 0.914, green: 0.945, blue: 0.949, alpha: 1.000)
        } else {
            self.elementContainer.backgroundColor = UIColor.whiteColor()
        }
    }

    override func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.isClosed!
    }
}
