//
//  SGModalItem.swift
//  SGSelectionModal
//
//  Created by Shubham Gupta on 10/09/18.
//  Copyright © 2018 Shubham Gupta. All rights reserved.
//

import UIKit

open class SGModalItem: NSObject {
    
    var itemTitle: String
    var handler: (() -> Void)?
    
    public init(item itemTitle: String) {
        self.itemTitle = itemTitle
    }
    
    public init(item itemTitle: String, didTapHandler: @escaping (() -> Void)) {
        self.itemTitle = itemTitle
        self.handler = didTapHandler
    }
    
    @objc func handlerTap() {
        handler?()
    }
}

