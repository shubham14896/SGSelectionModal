<img src="https://raw.githubusercontent.com/shubham14896/SGSelectionModal/master/Banner.jpg"></img>

# SGSelection Modal
> SGSelection Modal is a lightweight framework for Selecting out single/multiple value from a list.

![Version](https://img.shields.io/badge/Version-1.0.0-green.svg)
![Swift 3.0](https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat)
![License](https://img.shields.io/github/license/mashape/apistatus.svg)
![Author Shubham Gupta](https://img.shields.io/badge/Author-Shubham%20Gupta-blue.svg)

## About

Having trouble selecting out which state/city/{list} user/{entity} belongs to ???  Here's what you need, A lightweight framework built for selecting out a single/multiple values from a list.Built in using UIView, UIAnimations, ScrollView, UIButton. Initiate a object, add items to object, override closures and you are good to go.

## Features

- Single Select.
- Dynamic Width.
- Works on Landscape & Portrait Mode.
- Initiate with Selected Index.

## Requirements

- iOS 11.0+
- Xcode 9.0
- Swift 3.0+

## Installation

#### CocoaPods
Add following pod to project podfile.
````
  pod ’SGSelectionModal’
  ````
#### Manually

Download following files & add to your project.
- SGModal.swift.
- SGModalItem.swift.
- SGRadioButton.swift.

## Usage example
````
import SGSelectionModal

var selectedIndex: Int = 0

func showModal(){

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
````
## Preview
<img src="https://raw.githubusercontent.com/shubham14896/SGSelectionModal/master/Preview1.png"></img>
<img src="https://raw.githubusercontent.com/shubham14896/SGSelectionModal/master/Preview2.png"></img>


## Contribute
Any contribution to **SGSelection Modal** will be appreciated, check the ``LICENSE`` file for more info.
## Meta

Shubham Gupta – [@shubham14896](https://twitter.com/Shubham14896) – shubham9032@gmail.com

Distributed under the MIT license. See ``LICENSE`` for more information.

[https://github.com/shubham14896](https://github.com/shubham14896/)

