//
//  ViewController.swift
//  Example
//
//  Created by Shubham Gupta on 10/09/18.
//  Copyright © 2018 Shubham Gupta. All rights reserved.
//

import UIKit
import SGSelectionModal

class ViewController: UIViewController {
    
    var selectedIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func previewSGModal(_ sender: Any) {
        let modal = SGModal(title: "Select Country", closeButtonTitle: "Close")
        modal.width = 300
        modal.selectedIndex = selectedIndex
        for (index, state) in StateList.states.enumerated() {
            modal.addItem(item: state) {
                () in
                print(state)
                self.selectedIndex = index
            }
        }
        modal.show()
    }
}

