<p align="center">
    <img src="Resources/Icon-Badge.png" alt="Project Icon" width="250" />
</p>

<p align="center">
    <img src="https://img.shields.io/github/v/release/danielsaidi/RichTextKit?color=%2300550&sort=semver" alt="Version" />
    <img src="https://img.shields.io/badge/Swift-5.9-orange.svg" alt="Swift 5.9" />
    <img src="https://img.shields.io/badge/platform-SwiftUI-blue.svg" alt="Swift UI" title="Swift UI" />
    <a href="https://danielsaidi.github.io/RichTextKit"><img src="https://img.shields.io/badge/documentation-web-blue.svg" alt="Documentation" /></a>
        <a href="https://github.com/danielsaidi/RichTextKit/blob/master/LICENSE"><img src="https://img.shields.io/github/license/danielsaidi/RichTextKit" alt="MIT License" /></a>
    <a href="https://github.com/sponsors/danielsaidi"><img src="https://img.shields.io/badge/sponsor-GitHub-red.svg" alt="Sponsor my work" /></a>
</p>



# RichTextKit

RichTextKit is a library that lets you view and edit rich text in Swift and SwiftUI, on all major Apple platforms.

<p align="center">
    <img src ="Resources/Demo.jpg" />
</p>

The `RichTextEditor` supports text styles (bold, italic, underline, etc.), fonts, font sizes, colors, text alignments, image attachments, and much more. It's powered by a `RichTextView` that bridges `UITextView` & `NSTextView` and adds additional, platform-agnostic APIs that make the two views behave more alike.

If you just want to view rich text content, you can use the `RichTextViewer` SwiftUI view, which wraps the editor and applies a read-only configuration to it.


## ‼️ Important ‼️ 

This repository was created a few years ago, when SwiftUI had limited support for rich text. Since then, SwiftUI has received more support for attributed strings. And with the new iOS/macOS 26 releases, we can now edit attributed strings with a `TextEditor`.

This brings into questions how much value this repository will bring over time. It will most likely not be updated in its current direction, since most of its complexities to integrate between SwiftUI & UIKit/AppKit will not be needed.

It will most probably still be relevant to perform operations on the attributed string, and perhaps provide control panels, etc. Regardless, things will be different, so I am not yet sure if I will keep this library alive after the WWDC 25 announcements. Feel free to reach out to discuss this with me.

Best regards, Daniel Saidi



## Installation

RichTextKit can be installed with the Swift Package Manager:

```
https://github.com/danielsaidi/RichTextKit.git
```


## Support My Work

You can [become a sponsor][Sponsors] to help me dedicate more time on my various [open-source tools][OpenSource]. Every contribution, no matter the size, makes a real difference in keeping these tools free and actively developed.



## Getting started

RichTextKit has a SwiftUI ``RichTextEditor`` that takes a text binding and a ``RichTextContext``:

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
        .focusedValue(\.richTextContext, context)
    }
}
```

The editor uses a ``RichTextCoordinator`` to sync changes between the editor, context, and platform-specific view. You can use the context to change font, colors, alignment etc. and observe context changes to update the UI.

If you just want to display rich text, you can use the ``RichTextViewer`` instead:

```swift
struct MyView: View {

    private var text = NSAttributedString(...)

    var body: some View {
        RichTextViewer(text: text)
    }
}
```

RichTextKit provides UI components, keyboard shortcuts & menu commands that can be used in a rich text editor.

For more information, please see the [getting started guide][Getting-Started].



## Documentation

The [online documentation][Documentation] has more information, articles, code examples, etc.



## Demo App & Inspiration

The RichTextKit demo lets you explore the library on iOS & macOS. To try it out, just open and run the `Demo` app.



## Contact

Feel free to reach out if you have questions or want to contribute in any way:

* Website: [danielsaidi.com][Website]
* E-mail: [daniel.saidi@gmail.com][Email]
* Bluesky: [@danielsaidi@bsky.social][Bluesky]
* Mastodon: [@danielsaidi@mastodon.social][Mastodon]



## License

RichTextKit is available under the MIT license. See the [LICENSE][License] file for more info.



[Email]: mailto:daniel.saidi@gmail.com
[Website]: https://danielsaidi.com
[GitHub]: https://github.com/danielsaidi
[OpenSource]: https://danielsaidi.com/opensource
[Sponsors]: https://github.com/sponsors/danielsaidi

[Bluesky]: https://bsky.app/profile/danielsaidi.bsky.social
[Mastodon]: https://mastodon.social/@danielsaidi
[Twitter]: https://twitter.com/danielsaidi

[Documentation]: https://danielsaidi.github.io/RichTextKit/
[Getting-Started]: https://danielsaidi.github.io/RichTextKit/documentation/richtextkit/getting-started
[License]: https://github.com/danielsaidi/RichTextKit/blob/master/LICENSE
