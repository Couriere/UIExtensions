# UIExtensions

## Carthage integration:
[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

To integrate `UIExtensions` into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "Couriere/UIExtensions"
```
Run `carthage update` to build the framework and drag the built `UIExtensions.framework` into your Xcode project.

## Cocoapods integration:

To integrate `UIExtensions` into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/Couriere/cocoapods.git'

platform :ios, '9.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'UIExtensions'
end
```

Then, run the following command:

```
$ pod install
```
