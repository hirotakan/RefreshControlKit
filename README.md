# RefreshControlKit

![Swift 5](https://img.shields.io/badge/Swift-5-orange.svg)
[![License](https://img.shields.io/:license-mit-blue.svg)](http://doge.mit-license.org)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Cocoapods](https://img.shields.io/cocoapods/v/RefreshControlKit.svg)](http://cocoadocs.org/docsets/RefreshControlKit)
[![SwiftPM](https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
![Platforms](https://img.shields.io/badge/platforms-iOS-lightgrey.svg)

RefreshControlKit is a library for custom RefreshControl that can be used like [UIRefreshControl](https://developer.apple.com/documentation/uikit/uirefreshcontrol).


## Requirements
 - Swift 5 or later
 - iOS 12 or later
 
 
## Usage

[`RefreshControl`](https://github.com/hirotakan/RefreshControlKit/blob/master/Sources/RefreshControl.swift) can be used by using [`@RefreshControlling`](https://github.com/hirotakan/RefreshControlKit/blob/master/Sources/RefreshControlling.swift) of the [Property Wrappers](https://docs.swift.org/swift-book/LanguageGuide/Properties.html#ID617).

```swift
import UIKit
import RefreshControlKit

class ViewController: UIViewController {

    @RefreshControlling(wrappedValue: nil, view: CustomView())
    @IBOutlet private var myScrollingView: UIScrollView!

    // or

    @RefreshControlling(view: CustomView())
    private var myScrollingView = UIScrollView()

```

Since the [projected value](https://docs.swift.org/swift-book/LanguageGuide/Properties.html#ID619) is [`RefreshControl`](https://github.com/hirotakan/RefreshControlKit/blob/master/Sources/RefreshControl.swift), you can use it like [UIRefreshControl](https://developer.apple.com/documentation/uikit/uirefreshcontrol) by doing the following.

```swift
func configureRefreshControl () {

    $myScrollingView.addTarget(self, action:
                        #selector(handleRefreshControl),
                        for: .valueChanged)
}
    
@objc func handleRefreshControl() {
    // Update your content…

    // Dismiss the refresh control.
    DispatchQueue.main.async {
        self.$myScrollingView.endRefreshing()
    }
}

```

You can also use [`RefreshControl`](https://github.com/hirotakan/RefreshControlKit/blob/master/Sources/RefreshControl.swift) directly.

```swift
let refreshControl = RefreshControl(view: CustomView())
```

```swift
func configureRefreshControl () {

    myScrollingView.addRefreshControl(refreshControl)

    refreshControl.addTarget(self, action:
                      #selector(handleRefreshControl),
                      for: .valueChanged))
}

```

You can also start refreshing programmatically:

```swift
refreshControl.beginRefreshing()
```

## Creating custom RefreshControlView

In order to create a custom view, the following conditions must be met.

- Be a subclass of `UIView`
- Conforms to [`RefreshControlView`](https://github.com/hirotakan/RefreshControlKit/blob/master/Sources/RefreshControlView.swift)

```swift
class CustomView: UIView, RefreshControlView {

    func beginRefreshing() {
        // Something to do before refreshing.
    }

    func endRefreshing() {
        // Something to do after refreshing.
    }

    func scrolling(_ progress: RefreshControl.Progress) {
        // Something to do while scrolling.
        // `Progress` expresses the progress to the height of the trigger as 0.0 to 1.0.
    }
}

```

See the [sample code](https://github.com/hirotakan/RefreshControlKit/tree/master/Demo) for details.


## Configuration

```swift
public struct Configuration {
    public var layout: Layout
    public var trigger: Trigger
}

```

[`Layout`](https://github.com/hirotakan/RefreshControlKit/blob/master/Sources/RefreshControl%2BConfiguration.swift) and [`Trigger`](https://github.com/hirotakan/RefreshControlKit/blob/master/Sources/RefreshControl%2BConfiguration.swift) can be customized.


### Layout

[`Layout`](https://github.com/hirotakan/RefreshControlKit/blob/master/Sources/RefreshControl%2BConfiguration.swift) can be selected as `top` or `bottom`.

```swift
public enum Layout {
    /// The top of the `RefreshControl` is anchored at the top of the `ScrollView` frame.
    case top
    /// The bottom of the `RefreshControl` is anchored above the content of the `ScrollView`.
    case bottom
}
```

```swift
@RefreshControlling(view: CustomView(), configuration: .init(layout: .bottom))
private var myScrollingView = UIScrollView()
```

| top | bottom |
|:---:|:---:|
| <img src="https://github.com/hirotakan/RefreshControlKit/blob/master/Screenshot/top_dragging.gif"> | <img src="https://github.com/hirotakan/RefreshControlKit/blob/master/Screenshot/bottom_dragging.gif"> |


### Trigger

#### Height

```swift
@RefreshControlling(view: CustomView(), configuration: .init(trigger: .init(height: 50)))
private var myScrollingView = UIScrollView()
```

You can specify the height at which the refreshing starts. The default is the height of the custom view.


#### Event

[`Event`](https://github.com/hirotakan/RefreshControlKit/blob/master/Sources/RefreshControl%2BConfiguration.swift) can be selected as `dragging` or `released`.

```swift
public enum Event {
    /// When it is pulled to the trigger height, `beginRefreshing` is called.
    case dragging
    /// If the height of the trigger is exceeded at the time of release, `beginRefreshing` is called.
    case released
}
```

```swift
@RefreshControlling(view: CustomView(), configuration: .init(trigger: .init(event: .released)))
private var myScrollingView = UIScrollView()
```

| dragging | released |
|:---:|:---:|
| <img src="https://github.com/hirotakan/RefreshControlKit/blob/master/Screenshot/bottom_dragging.gif"> | <img src="https://github.com/hirotakan/RefreshControlKit/blob/master/Screenshot/bottom_released.gif"> |


## Installation

### SwiftPM

Add RefreshControlKit as a dependency:

```swift
import PackageDescription

let package = Package(
    name: "YourApp",
    dependencies: [
        .Package(url: "https://github.com/hirotakan/RefreshControlKit.git", majorVersion: 0),
    ]
)
```

### CocoaPods

Add the following to your Podfile:

```terminal
pod 'RefreshControlKit'
```

### Carthage

Add the following to your Cartfile:

```terminal
github "hirotakan/RefreshControlKit"
```


## License

RefreshControlKit is released under the MIT license. See [LICENSE](https://github.com/hirotakan/RefreshControlKit/blob/master/LICENSE) for details.

