# Getting Started

RichTextKit is a Swift-based library that lets you work with rich text in UIKit, AppKit and SwiftUI.

This article is currently limited in scope, but will be expanded in upcoming versions.


## UIKit and AppKit

In UIKit and AppKit, you can start with creating ``RichTextView`` view instead of a `UITextView` or `NSTextView`.

```swift
let view = RichTextView()
```

When you have the text view, you can set it up with `setup(with:format:)` to set it up with a text and a ``RichTextDataFormat``:

```swift
view.setup(with: "A rich text", format: .archivedData)
```

The data format determines how the content is handled, for instance `.txt`, `.rtf` and a custom `.archivedData`, which supports storing images inline.

`RichTextView` has more functionality than `UITextView` or `NSTextView` to simplify working with rich text in similar way on all platforms. RichTextKit also adds a bunch of additional functionality to native types, to simplify working with styles, alignments, images etc.  

Have a look at the demo app for more examples. 


## SwiftUI

In SwiftUI, you can use a ``RichTextEditor`` to wrap a ``RichTextView`` and use it in SwiftUI. You must also create a ``RichTextContext`` to setup and interact with the editor.

```swift
struct MyView: View {

    @State
    private var text = NSAttributedString(string: "Type here...")
    
    @StateObject
    var context = RichTextContext()

    var body: some View {
        RichTextEditor(text: $text, context: context) {
            // You can customize the native text view here
            $0.textContentInset = CGSize(width: 10, height: 20)
        }
    }
}
```

The ``RichTextEditor`` connects the ``RichTextContext`` with a ``RichTextCoordinator``, which coordinates changes in both the context and the text view. 

You can now use the context to change font, font size, colors, alignment etc. The context will set properties which are observed by the coordinator, and the coordinator will also observe the text view and sync any changes to the context.

For instance, to display the current font size, you can observe and display the value of the context's ``RichTextContext/fontSize``. You can also set a new value to have the coordinator sync the value with the text view.

```swift
print("The current font size is \(context.fontSize)")
```

```swift
Button("Set font size") {
    context.fontSize = 123
}
```

This means that in SwiftUI, you really only have to use the ``RichTextEditor`` and the ``RichTextContext``. RichTextKit will take care of everything, using functionality which is also available to you if you want to dig deeper.
