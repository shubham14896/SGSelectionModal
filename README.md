<img src="https://raw.githubusercontent.com/shubham14896/SGSelectionModal/master/Banner.jpg"></img>

# SGSelection Modal
> SGSelection Modal is a lightweight framework for Selecting out single/multiple value from a list.

[![Version](https://img.shields.io/cocoapods/v/Presentr.svg?style=flat)](http://cocoapods.org/pods/Presentr)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Swift 3.0](https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Platform](https://img.shields.io/cocoapods/p/Presentr.svg?style=flat)](http://cocoapods.org/pods/Presentr)
[![License](https://img.shields.io/cocoapods/l/Presentr.svg?style=flat)](http://cocoapods.org/pods/Presentr)
[![codebeat badge](https://codebeat.co/badges/f89d5cdf-b0c3-441d-b4e1-d56dcea48544)](https://codebeat.co/projects/github-com-icalialabs-presentr)
![Made with Love by Shubham Gupta](https://img.shields.io/badge/With%20love%20by-Icalia%20Labs-ff3434.svg)

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

## Contribute
We would love you for the contribution to **SGSelection Modal**, check the ``LICENSE`` file for more info.
## Meta

Shubham Gupta – [@YourTwitter](https://twitter.com/Shubham14896) – shubham9032@gmail.com

Distributed under the MIT license. See ``LICENSE`` for more information.

[https://github.com/shubham14896](https://github.com/shubham14896/)

[swift-image]:https://img.shields.io/badge/swift-3.0-orange.svg
[swift-url]: https://swift.org/
[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: LICENSE

