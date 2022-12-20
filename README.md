<p align="center">
    <img src ="Resources/Logo.png" alt="RichTextKit Logo" title="RichTextKit" width=600 />
</p>

<p align="center">
    <img src="https://img.shields.io/github/v/release/danielsaidi/RichTextKit?color=%2300550&sort=semver" alt="Version" />
    <img src="https://img.shields.io/badge/Swift-5.6-orange.svg" alt="Swift 5.6" />
    <img src="https://img.shields.io/github/license/danielsaidi/RichTextKit" alt="MIT License" />
    <a href="https://twitter.com/danielsaidi">
        <img src="https://img.shields.io/badge/contact-@danielsaidi-blue.svg?style=flat" alt="Twitter: @danielsaidi" />
    </a>
</p>


## About RichTextKit

RichTextKit lets you edit rich text in UIKit, AppKit, and SwiftUI. It has a multi-platform `RichTextView` and a SwiftUI `RichTextEditor` and supports changing style (bold, italic, underline etc.), font, font sizes, colors, text alignment, etc. You can even drag in and paste images if you use a data format that allows it. 

RichTextKit is supported by and released with permission from [Oribi](https://oribi.se/en/) and used in [OribiWriter](https://oribi.se/en/apps/oribi-writer/), which is out on iOS and soon on macOS. Have a look at that app or the demo app in this repo if you want to see RichTextKit in action.



## Installation

RichTextKit can be installed with the Swift Package Manager:

```
https://github.com/danielsaidi/RichTextKit.git
```

or with CocoaPods:

```
pod RichTextKit
```



## Supported Platforms

RichTextKit supports `iOS 14`, `macOS 11`, `tvOS 14` and `watchOS 7`.



## Getting started

In UIKit and AppKit, you can start with creating ``RichTextView`` view instead of a `UITextView` or `NSTextView`:

```swift
RichTextView(data: myData, format: .archivedData)  // Using data
RichTextView(string: myString, format: .plainText) // Using a string
```

`RichTextView` has a lot more functionality than the native views and bridges the platform-specific api:s so that the views behave more alike. You can use this text view like a regular view to view or edit rich text.

In SwiftUI, you can use a ``RichTextEditor``, which connects a wrapped ``RichTextView`` with a ``RichTextContext``:

```swift
struct MyView: View {

    @State
    private var text = NSAttributedString(string: "Type here...")
    
    @StateObject
    var context = RichTextContext()

    var body: some View {
        RichTextEditor(text: $text, context: context) {
            // You can customize the native text view here
        }
    }
}
```

The ``RichTextEditor`` uses an internal coordinator that coordinates changes between the context and the editor. You can now use the context to change font, font size, colors, alignment etc. and observe how these properties change when you move the cursor around the text view.

Other than these views, RichTextKit has a bunch of additional functionality to native types, to simplify working with rich text attrbutes, styles, fonts, text alignments, image attachments etc. It uses extensions and protocols to unify native and library types and has pickers, menus, toolbars etc. to help you build a great rich text editor. 

For more information and examples, the [online documentation][Documentation] has a [getting started][GettingStarted] guide to help you get started with RichTextKit.



## Documentation

The [online documentation][Documentation] contains more information, code examples, etc., and makes it easy to overview the various parts of the library.



## Demo Application

This project contains a demo app that lets you explore RichTextKit on iOS and macOS. To run it, just open and run `Demo/Demo.xcodeproj`.



## Support

You can sponsor this project on [GitHub Sponsors][Sponsors] or get in touch for paid support. 



## Contact

Feel free to reach out if you have questions or if you want to contribute in any way:

* E-mail: [daniel.saidi@gmail.com][Email]
* Twitter: [@danielsaidi][Twitter]
* Web site: [danielsaidi.com][Website]



## License

RichTextKit is available under the MIT license. See the [LICENSE][License] file for more info.



[Email]: mailto:daniel.saidi@gmail.com
[Twitter]: http://www.twitter.com/danielsaidi
[Website]: http://www.danielsaidi.com
[Sponsors]: https://github.com/sponsors/danielsaidi

[Documentation]: https://danielsaidi.github.io/RichTextKit/documentation/richtextkit/
[GettingStarted]: https://danielsaidi.github.io/RichTextKit/documentation/richtextkit/getting-started
[License]: https://github.com/danielsaidi/RichTextKit/blob/master/LICENSE
