<p align="center">
    <img src ="Resources/Logo_GitHub.png" alt="RichTextKit Logo" title="RichTextKit" />
</p>

<p align="center">
    <img src="https://img.shields.io/github/v/release/danielsaidi/RichTextKit?color=%2300550&sort=semver" alt="Version" />
    <img src="https://img.shields.io/badge/Swift-5.9-orange.svg" alt="Swift 5.9" />
    <img src="https://img.shields.io/badge/platform-SwiftUI-blue.svg" alt="Swift UI" title="Swift UI" />
    <img src="https://img.shields.io/github/license/danielsaidi/RichTextKit" alt="MIT License" />
    <a href="https://twitter.com/danielsaidi"><img src="https://img.shields.io/twitter/url?label=Twitter&style=social&url=https%3A%2F%2Ftwitter.com%2Fdanielsaidi" alt="Twitter: @danielsaidi" title="Twitter: @danielsaidi" /></a>
    <a href="https://mastodon.social/@danielsaidi"><img src="https://img.shields.io/mastodon/follow/000253346?label=mastodon&style=social" alt="Mastodon: @danielsaidi@mastodon.social" title="Mastodon: @danielsaidi@mastodon.social" /></a>
</p>



## About RichTextKit

RichTextKit is a Swift SDK that lets you edit rich text in `Swift` & `SwiftUI` with a multi-platform `RichTextEditor`:

<p align="center">
    <img src ="Resources/Demo.jpg" />
</p>

The `RichTextEditor` supports text styles (bold, italic, underline, etc.), fonts, font sizes, colors, text alignments, image attachments, and much more. It's powered by a `RichTextView` that bridges `UITextView` & `NSTextView` and adds additional, platform-agnostic APIs that make the two views behave more alike.

If you just want to view rich text connte, you can use the `RichTextViewer` SwiftUI view, which wraps the editor and applies a read-only configuration to it.



## Installation

RichTextKit can be installed with the Swift Package Manager:

```
https://github.com/danielsaidi/RichTextKit.git
```



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



## Demo Application

The demo app lets you explore the library on iOS and macOS. To try it out, just open and run the `Demo` project.



## Sponsor my work

Please consider supporting my work if you find this and my other [open-source projects][OpenSource] helpful.

You can [sponsor me][Sponsors] on GitHub Sponsors or [reach out][Email] for paid support, or hire me for [freelance work][Website].



## Contact

Feel free to reach out if you have questions or want to contribute in any way:

* Website: [danielsaidi.com][Website]
* Mastodon: [@danielsaidi@mastodon.social][Mastodon]
* Twitter: [@danielsaidi][Twitter]
* E-mail: [daniel.saidi@gmail.com][Email]



## Used in

RichTextKit is used in the following apps, so make sure to check them out for inspiration:

<a title="Chunk" href="https://www.curioussoftware.io"><img src="Resources/apps/chunk.png" width=100 /></a> 
<a title="Oribi Writer" href="https://oribi.se/en"><img src="Resources/apps/oribiwriter.png" width=100 /></a>

Feel free to reach out if you are using RichTextKit and want to add your app to this list.



## License

RichTextKit is available under the MIT license. See the [LICENSE][License] file for more info.



[Email]: mailto:daniel.saidi@gmail.com

[Website]: https://www.danielsaidi.com
[GitHub]: https://www.github.com/danielsaidi
[Twitter]: https://www.twitter.com/danielsaidi
[Mastodon]: https://mastodon.social/@danielsaidi
[Sponsors]: https://github.com/sponsors/danielsaidi
[OpenSource]: https://www.danielsaidi.com/opensource

[Documentation]: https://danielsaidi.github.io/RichTextKit/documentation/richtextkit/
[Getting-Started]: https://danielsaidi.github.io/RichTextKit/documentation/richtextkit/getting-started
[License]: https://github.com/danielsaidi/RichTextKit/blob/master/LICENSE
