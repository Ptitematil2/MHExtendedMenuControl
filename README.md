# MHExtendedMenuControl

[![CI Status](http://img.shields.io/travis/Mathilde Henriot/MHExtendedMenuControl.svg?style=flat)](https://travis-ci.org/Mathilde Henriot/MHExtendedMenuControl)
[![Version](https://img.shields.io/cocoapods/v/MHExtendedMenuControl.svg?style=flat)](http://cocoapods.org/pods/MHExtendedMenuControl)
[![License](https://img.shields.io/cocoapods/l/MHExtendedMenuControl.svg?style=flat)](http://cocoapods.org/pods/MHExtendedMenuControl)
[![Platform](https://img.shields.io/cocoapods/p/MHExtendedMenuControl.svg?style=flat)](http://cocoapods.org/pods/MHExtendedMenuControl)

MHExtendedMenuControl allows you to create a bouncing menu with multiple buttons

## Version

0.1.0

## Installation

MHExtendedMenuControl is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "MHExtendedMenuControl"
```

## Usage

Import the library where you need it.
```ruby
#import <MHExtendedMenuControl.h>
```

Then you can create your menu like this :
```ruby
int menuSize = 60;
int numberOfButtons = 3;
int marginSize = 20;
int numberOfMargin = 2;

MHExtendedMenuControl *expandableMenu = [[MHExtendedMenuControl alloc] initWith:numberOfButtons buttonsWithImages:@[[UIImage imageNamed:@"Avengers-Black-Widow-icon"], [UIImage imageNamed:@"Avengers-Hawkeye-icon"], [UIImage imageNamed:@"Hopstarter-Superhero-Avatar-Avengers-Nick-Fury"]]  animation:MHExtendedMenuAnimationRight andDelegate:self];
expandableMenu.frame = CGRectMake(marginSize, CGRectGetMaxY(self.view.frame)-menuSize-marginSize, menuSize*numberOfButtons+marginSize*numberOfMargin, menuSize);
[self.view addSubview:expandableMenu];

```


## Author

Mathilde Henriot, me@mathilde-henriot.com

## License

MHExtendedMenuControl is available under the MIT license. See the LICENSE file for more info.
