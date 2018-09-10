//
//  SGRadioButton.swift
//  SGSelectionModal
//
//  Created by Shubham Gupta on 10/09/18.
//  Copyright © 2018 Shubham Gupta. All rights reserved.
//

import UIKit

public class SGRadioButton: UIButton {
    
    var indexPath:IndexPath!
    
    public var animationDuration:CFTimeInterval = 0.03
    
    static let kGeneratedIconName:String = "Rendered Icon"
    
    static var  _groupModifing:Bool = false
    
    var otherButtons: Array<SGRadioButton>?
    
    public var iconSize:CGFloat = 15.0
    
    public var indicatorSize:CGFloat = 15.0 * 0.5
    
    public var iconColor:UIColor =  UIColor.black
    
    public var iconStrokeWidth:CGFloat = 1.6
    
    public var indicatorColor:UIColor = UIColor.black
    
    public var marginWidth:CGFloat = 10.0
    
    public var iconOnRight:Bool = false
    
    public var iconSquare:Bool = false
    
    public var icon:UIImage!
    
    public var iconSelected:UIImage!
    
    public var multipleSelectionEnabled:Bool = false
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.initRadioButton()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initRadioButton()
    }
    
    override public func draw(_ rect:CGRect) {
        super.draw(rect)
        self.drawButton()
    }
    
    private var setOtherButtons:NSArray {
        get{
            return otherButtons! as NSArray
        }
        set (newValue) {
            if (!self.isGroupModifing()){
                self.groupModifing(chaining: true)
                let otherNewButtons:Array<SGRadioButton>? = newValue as? Array<SGRadioButton>
                for radioButton in otherNewButtons!{
                    let otherButtonsForCurrentButton:NSMutableArray = NSMutableArray(array:otherNewButtons!)
                    otherButtonsForCurrentButton.add(self)
                    otherButtonsForCurrentButton.remove(radioButton)
                    radioButton.setOtherButtons = otherButtonsForCurrentButton
                }
                self.groupModifing(chaining: false)
            }
            self.otherButtons = newValue as? Array<SGRadioButton>
        }
    }
    
    public var setIcon:UIImage {
        
        get{
            return icon
        }
        
        set (newValue){
            icon = newValue
            self.setImage(icon, for: .normal)
        }
    }
    
    public var setIconSelected:UIImage {
        
        get{
            return iconSelected
        }
        
        set (newValue){
            iconSelected = newValue
            self.setImage(iconSelected, for: .selected)
            self.setImage(iconSelected, for: .highlighted)
        }
    }
    
    public var setAnimationDuration:CFTimeInterval{
        get {
            return animationDuration
        }
        
        set(newValue) {
            if (!self.isGroupModifing()){
                self.groupModifing(chaining: true)
                if self.otherButtons != nil {
                    for radioButton in self.otherButtons!{
                        radioButton.animationDuration = newValue
                    }
                }
                self.groupModifing(chaining: false)
            }
            animationDuration = newValue
        }
    }
    
    public var setMultipleSelectionEnabled:Bool {
        
        get{
            return multipleSelectionEnabled
        }
        set (newValue) {
            if (!self.isGroupModifing()){
                self.groupModifing(chaining: true)
                if self.otherButtons != nil {
                    for radioButton in self.otherButtons!{
                        radioButton.multipleSelectionEnabled = newValue
                    }
                }
                self.groupModifing(chaining: false)
            }
            multipleSelectionEnabled = newValue
        }
    }
    
    func drawButton (){
        if (self.icon == nil){
            self.setIcon = self.drawIconWithSelection(false)
        }else{
            self.setIcon = self.icon ;
        }
        
        if (iconSelected == nil){
            self.setIconSelected = self.drawIconWithSelection(true)
        }else{
            self.setIconSelected = self.iconSelected;
        }
        
        if self.otherButtons != nil {
            self.setOtherButtons = self.otherButtons! as NSArray
        }
        
        if multipleSelectionEnabled {
            self.setMultipleSelectionEnabled = multipleSelectionEnabled
        }
        
        if self.iconOnRight {
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: self.frame.size.width - self.icon.size.width + marginWidth - 20, bottom: 0, right: 0);
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: marginWidth + self.icon.size.width);
            self.contentHorizontalAlignment = .left
            self.titleLabel?.textAlignment = .left
        } else {
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: marginWidth, bottom: 0, right: 0);
            self.titleLabel?.textAlignment = .left
            self.contentHorizontalAlignment = .left
        }
        self.titleLabel?.adjustsFontSizeToFitWidth = false
    }
    
    func drawIconWithSelection (_ selected:Bool) -> UIImage{
        
        let rect:CGRect = CGRect(x: 0, y: 0, width: iconSize, height: iconSize)
        let context  = UIGraphicsGetCurrentContext()
        UIGraphicsPushContext(context!)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0);
        
        var iconPath:UIBezierPath!
        let iconRect:CGRect = CGRect(x: iconStrokeWidth / 2, y: iconStrokeWidth / 2, width: iconSize - iconStrokeWidth, height: iconSize - iconStrokeWidth);
        if self.iconSquare {
            iconPath = UIBezierPath(rect:iconRect )
        } else {
            iconPath = UIBezierPath(ovalIn:iconRect)
        }
        iconColor.setStroke()
        iconPath.lineWidth = iconStrokeWidth;
        iconPath.stroke()
        context?.addPath(iconPath.cgPath);
        
        if (selected) {
            var indicatorPath:UIBezierPath!
            let indicatorRect:CGRect = CGRect(x: (iconSize - indicatorSize) / 2, y: (iconSize - indicatorSize) / 2, width: indicatorSize, height: indicatorSize);
            if self.iconSquare {
                indicatorPath = UIBezierPath(rect:indicatorRect )
            } else {
                indicatorPath = UIBezierPath(ovalIn:indicatorRect)
            }
            indicatorColor.setStroke()
            indicatorPath.lineWidth = iconStrokeWidth;
            indicatorPath.stroke()
            
            indicatorColor.setFill()
            indicatorPath.fill()
            context?.addPath(indicatorPath.cgPath);
        }
        
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsPopContext()
        UIGraphicsEndImageContext();
        image.accessibilityIdentifier = SGRadioButton.kGeneratedIconName;
        return image;
    }
    
    @objc func touchDown () {
        //if self.isSelected {
        //self.isSelected = false
        //}else{
        self.isSelected = true
        //}
    }
    
    func initRadioButton () {
        super.addTarget(self, action:#selector(SGRadioButton.touchDown), for:.touchUpInside)
        //self.isSelected = false
    }
    
    override public func prepareForInterfaceBuilder () {
        self.initRadioButton()
        self.drawButton()
    }
    
    
    func groupModifing(chaining:Bool) {
        SGRadioButton._groupModifing = chaining
    }
    
    func isGroupModifing() -> Bool {
        return SGRadioButton._groupModifing
    }
    
    public func selectedButton() -> SGRadioButton!{
        if !self.multipleSelectionEnabled {
            if self.isSelected {
                return self
            }
        }else{
            for isRadioButton in self.otherButtons!  {
                if isRadioButton.isSelected {
                    return isRadioButton
                }
            }
        }
        return nil
    }
    
    public func selectedButtons() -> NSMutableArray{
        
        let selectedButtons:NSMutableArray = NSMutableArray ()
        if self.isSelected {
            selectedButtons.add(self)
        }
        for radioButton in self.otherButtons!  {
            if radioButton.isSelected {
                selectedButtons .add(self)
            }
        }
        return selectedButtons;
    }
    
    public func deselectOtherButtons() {
        if self.otherButtons != nil {
            for radioButton in self.otherButtons!  {
                radioButton.isSelected = false
            }
        }
    }
    
    public func unSelectedButtons() -> NSArray{
        let unSelectedButtons:NSMutableArray = NSMutableArray ()
        if self.isSelected == false {
            unSelectedButtons.add(self)
        }
        for isRadioButton in self.otherButtons!  {
            if isRadioButton.isSelected == false {
                unSelectedButtons.add(self)
            }
        }
        return unSelectedButtons ;
    }
    
    override public func titleColor(for state:UIControlState) -> UIColor{
        if (state == UIControlState.selected || state == UIControlState.highlighted){
            var selectedOrHighlightedColor:UIColor!
            if (state == UIControlState.selected) {
                selectedOrHighlightedColor = super.titleColor(for: .selected)
            }else{
                selectedOrHighlightedColor = super.titleColor(for: .highlighted)
            }
            self.setTitleColor(selectedOrHighlightedColor, for: .selected)
            self.setTitleColor(selectedOrHighlightedColor, for: .highlighted)
        }
        return super.titleColor(for: state)!
    }
    
    override public var isSelected: Bool {
        
        didSet {
            
            if (multipleSelectionEnabled || oldValue != self.isSelected && self.animationDuration > 0.0) {
                
                if self.iconSelected != nil && self.icon != nil {
                    let animation = CABasicAnimation(keyPath: "contents")
                    if self.isSelected {
                        animation.fromValue = self.iconSelected.cgImage
                    }else{
                        animation.fromValue = self.icon.cgImage
                    }
                    
                    if self.isSelected {
                        animation.toValue = self.icon.cgImage
                    }else{
                        animation.toValue = self.iconSelected.cgImage
                    }
                    animation.duration = self.animationDuration
                    self.imageView?.layer.add(animation, forKey:"icon" )
                }
            }
            
            if (multipleSelectionEnabled) {
                if oldValue == true && self.isSelected == true {
                    super.isSelected = false
                }else{
                    super.isSelected = true
                }
            }else {
                if ( oldValue == false && self.isSelected == true ) {
                    self.deselectOtherButtons()
                }
            }
        }
    }
}
