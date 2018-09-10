//
//  SGModal.swift
//  SGSelectionModal
//
//  Created by Shubham Gupta on 10/09/18.
//  Copyright © 2018 Shubham Gupta. All rights reserved.
//

import UIKit

open class SGModal: UIView {
    
    open var items: [SGModalItem] = []
    
    open var titleHeight: CGFloat = 50
    open var buttonHeight: CGFloat = 50
    open var cornerRadius: CGFloat = 7
    open var itemPadding: CGFloat = 10
    open var minHeight: CGFloat = 200
    open var width: CGFloat = 150
    open var selectedIndex: Int = 0
    
    open var title: String? = "Title"
    open var closeButtonTitle: String? = "Close"
    open var closeButtonColor: UIColor?
    open var closeButtonColorHighlighted: UIColor?
    
    private var scrollY:CGFloat = 0
    
    fileprivate var dialogView: UIView?
    
    public init() {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        setObservers()
    }
    
    public init(title: String, closeButtonTitle cancelString: String) {
        self.title = title
        self.closeButtonTitle = cancelString
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        setObservers()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setObservers()
    }
    
    open func show() {
        dialogView = createDialogView()
        guard let dialogView = dialogView else { return }
        
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        self.backgroundColor = UIColor(white: 0, alpha: 0)
        let tapGestures = UITapGestureRecognizer(target: self, action: #selector(SGModal.close))
        self.addGestureRecognizer(tapGestures)
        
        dialogView.layer.opacity = 0.5
        dialogView.layer.transform = CATransform3DMakeScale(1.3, 1.3, 1)
        
        self.addSubview(dialogView)
        
        self.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        UIApplication.shared.keyWindow?.addSubview(self)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions() , animations: {
            self.backgroundColor = UIColor(white: 0, alpha: 0.4)
            dialogView.layer.opacity = 1
            dialogView.layer.transform = CATransform3DMakeScale(1, 1, 1)
        }, completion: nil)
    }
    
    @objc open func close() {
        guard let dialogView = dialogView else { return }
        let currentTransform = dialogView.layer.transform
        
        dialogView.layer.opacity = 1
        
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.backgroundColor = UIColor(white: 0, alpha: 0)
            dialogView.layer.transform = CATransform3DConcat(currentTransform, CATransform3DMakeScale(0.6, 0.6, 1))
            dialogView.layer.opacity = 0
        }, completion: { (finished: Bool) in
            for view in self.subviews {
                view.removeFromSuperview()
            }
            self.removeFromSuperview()
        })
    }
    
    open func addItem(item itemTitle: String) {
        let item = SGModalItem(item: itemTitle)
        items.append(item)
    }
    
    open func addItem(item itemTitle: String, didTapHandler: @escaping (() -> Void)) {
        let item = SGModalItem(item: itemTitle, didTapHandler: didTapHandler)
        items.append(item)
    }
    
    open func addItem(_ item: SGModalItem) {
        items.append(item)
    }
    
    fileprivate func setObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(SGModal.deviceOrientationDidChange(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    fileprivate func createDialogView() -> UIView {
        let screenSize = self.calculateScreenSize()
        let dialogSize = self.calculateDialogSize()
        
        let view = UIView(frame: CGRect(
            x: (screenSize.width - dialogSize.width) / 2,
            y: (screenSize.height - dialogSize.height) / 2,
            width: dialogSize.width,
            height: dialogSize.height
        ))
        
        view.layer.cornerRadius = cornerRadius
        view.backgroundColor = UIColor.white
        view.layer.shadowRadius = cornerRadius
        view.layer.shadowOpacity = 0.2
        view.layer.shadowColor = UIColor.black.cgColor
        
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
        
        view.addSubview(createTitleLabel())
        view.addSubview(createContainerView())
        view.addSubview(createCloseButton())
        return view
    }
    
    fileprivate func createContainerView() -> UIScrollView {
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 0))
        let firstRadioButton = SGRadioButton()
        let otherButtons:NSMutableArray = NSMutableArray()
        
        for (index, item) in items.enumerated() {
            
            var radioButton = SGRadioButton()
            
            if selectedIndex == index {
                radioButton = firstRadioButton
            }
            
            radioButton.frame = CGRect(x: 0, y: CGFloat(index*50), width: width-10, height: 49)
            radioButton.setTitle(item.itemTitle, for: UIControlState())
            radioButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
            radioButton.setTitleColor(UIColor.black, for: UIControlState())
            radioButton.iconOnRight = true;
            radioButton.multipleSelectionEnabled = false
            radioButton.iconColor = UIColor.black
            radioButton.indicatorColor = UIColor.black
            radioButton.addTarget(item, action: #selector(SGModalItem.handlerTap), for: .touchUpInside)
            containerView.addSubview(radioButton)
            otherButtons.add(radioButton)
            
            if selectedIndex == index {
                radioButton.isSelected = true
                scrollY = CGFloat(index * 50)
            }
            
            let divider = UIView(frame: CGRect(x: 0, y: CGFloat(index*50)+50, width: width, height: 0.5))
            divider.backgroundColor = UIColor.lightGray
            containerView.addSubview(divider)
            containerView.frame.size.height += 50
        }
        
        firstRadioButton.otherButtons = (otherButtons as AnyObject as! Array<SGRadioButton>)
        
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: titleHeight, width: width, height: minHeight))
        scrollView.contentSize.height = CGFloat(items.count*50)
        scrollView.addSubview(containerView)
        scrollView.flashScrollIndicators()
        
        let maxScrollY = scrollView.contentSize.height - scrollView.bounds.size.height
        let bottomOffset = CGPoint(x: 0, y: scrollY > maxScrollY ? maxScrollY : scrollY)
        scrollView.setContentOffset(bottomOffset, animated: true)
        
        return scrollView
    }
    
    fileprivate func createTitleLabel() -> UIView {
        
        let view = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: titleHeight))
        view.text = title
        view.textAlignment = .center
        view.font = UIFont.boldSystemFont(ofSize: 18.0)
        
        let bottomLayer = CALayer()
        bottomLayer.frame = CGRect(x: 0, y: view.bounds.size.height, width: view.bounds.size.width, height: 0.5)
        bottomLayer.backgroundColor = UIColor(red: 198/255, green: 198/255, blue: 198/255, alpha: 1).cgColor
        view.layer.addSublayer(bottomLayer)
        
        return view
    }
    
    fileprivate func createCloseButton() -> UIButton {
        let minValue = min(CGFloat(items.count)*50.0, minHeight)
        let button = UIButton(frame: CGRect(x: 0, y: titleHeight + minValue, width: width, height: buttonHeight))
        
        button.addTarget(self, action: #selector(SGModal.close), for: UIControlEvents.touchUpInside )
        
        let colorNormal = closeButtonColor != nil ? closeButtonColor : button.tintColor
        let colorHighlighted = closeButtonColorHighlighted != nil ? closeButtonColorHighlighted : colorNormal?.withAlphaComponent(0.5)
        
        button.setTitle(closeButtonTitle, for: UIControlState())
        button.setTitleColor(colorNormal, for: UIControlState())
        button.setTitleColor(colorHighlighted, for: UIControlState.highlighted)
        button.setTitleColor(colorHighlighted, for: UIControlState.disabled)
        
        let topLayer = CALayer()
        topLayer.frame = CGRect(x: 0, y: 0, width: 300, height: 0.5)
        topLayer.backgroundColor = UIColor(red: 198/255, green: 198/255, blue: 198/255, alpha: 1).cgColor
        button.layer.addSublayer(topLayer)
        
        return button
    }
    
    fileprivate func calculateDialogSize() -> CGSize {
        let minValue = min(CGFloat(items.count)*50.0, minHeight)
        return CGSize(width: width, height: minValue + titleHeight + buttonHeight)
    }
    
    fileprivate func calculateScreenSize() -> CGSize {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        return CGSize(width: width, height: height)
    }
    
    @objc internal func deviceOrientationDidChange(_ notification: Notification) {
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        
        let screenSize = self.calculateScreenSize()
        let dialogSize = self.calculateDialogSize()
        
        dialogView?.frame = CGRect(
            x: (screenSize.width - dialogSize.width) / 2,
            y: (screenSize.height - dialogSize.height) / 2,
            width: dialogSize.width,
            height: dialogSize.height
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
}

