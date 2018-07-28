# NKFrameLayoutKit

[![Version](https://img.shields.io/cocoapods/v/NKFrameLayoutKit.svg?style=flat)](http://cocoapods.org/pods/NKFrameLayoutKit)
[![License](https://img.shields.io/cocoapods/l/NKFrameLayoutKit.svg?style=flat)](http://cocoapods.org/pods/NKFrameLayoutKit)
[![Platform](https://img.shields.io/cocoapods/p/NKFrameLayoutKit.svg?style=flat)](http://cocoapods.org/pods/NKFrameLayoutKit)

NKFrameLayout is a super fast and easy to use layout library for iOS and tvOS.

For Swift version, check here: [FrameLayoutKit](http://github.com/kennic/FrameLayoutKit)

## Example

![Grid Example](/../master/example_grid.png?raw=true "NKGridFrameLayout example")

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

NKFrameLayoutKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "NKFrameLayoutKit"
```

## Hello world

```swift
let image = UIImage(named: "earth.jpg")

let label = UILabel()
label.text = "Hello World"

let layout = NKDoubleFrameLayout(direction: .horizontal, andViews: [image, label])
layout.spacing = 5
layout.edgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
layout.frame = self.bounds
```
![Hello World](/helloWorld.png "Hello World")

## Benchmark
NKFrameLayoutKit is one of the fastest layout libraries.
![Benchmark Results](/bechmark.png "Benchmark results")

See: [Layout libraries benchmark's project](https://github.com/layoutBox/LayoutFrameworkBenchmark)

## Todo

- [x] CocoaPods support
- [x] Objective-C version
- [x] Swift version
- [ ] Examples
- [ ] Documents

## Author

Nam Kennic, namkennic@me.com

## License

NKFrameLayoutKit is available under the MIT license. See the LICENSE file for more info.
