# Getting Started

RichTextKit is a Swift-based library that lets you work with rich text in UIKit, AppKit and SwiftUI.

This article is currently limited in scope, but will be expanded in upcoming versions.


## UIKit and AppKit

In UIKit and AppKit, you can start with creating ``RichTextView`` view instead of a `UITextView` or `NSTextView`.

```swift
let view = RichTextView()
```

You can then set up the view with `setup(with:format:)` to set it up with a text and a ``RichTextDataFormat``:

```swift
view.setup(with: "A rich text", format: .archivedData)
```

The data format determines how content is handled. For instance, `.archivedData` will archive rich text and image attachments into the text itself, while `.rtf` supports rich content but requires additional handling of images and `.plainText` only supports plain text without formatting.

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

The ``RichTextEditor`` connects the ``RichTextContext`` with an internal ``RichTextCoordinator``, which coordinates changes in both the context and the text view. 

You can now use the context to change font, font size, colors, alignment etc. The context will set properties which are observed by the coordinator, which also observe the text view and syncs any changes between the two.

For instance, to display the current font size, you can observe and display the value of the context's ``RichTextContext/fontSize``. You can also set a new value to have the coordinator sync the value with the text view.

```swift
print("The current font size is \(context.fontSize)")
```

```swift
Button("Set font size") {
    context.fontSize = 123
}
```

This means that in SwiftUI, you only have to use a ``RichTextEditor`` and a ``RichTextContext``. RichTextKit will take care of everything, using functionality which is also available to you if you want to dig deeper.


## Terminology

RichTextKit mostly tries to use native terminology, but has a couple of custom names that may require a bit of explanation.

For instance, a `reader` is anything that can access certain information, but not modify it, while a `writer` is anything that can modify certain things.

These concepts are available as protocols, like for instance the ``RichTextAlignmentReader`` and ``RichTextAlignmentWriter`` protocols. These protocols are then most often auto-implemented by various native types as well as types in the library.

For instance `NSAttributedString` implements many reader protocols, while `NSMutableAttributedString` implements many writer protocols.

Having these protocols make it easy to isolate functionality and have that functionality readily available to any type that implements a certain protocol.


## SwiftUI views

This will eventually be a separate article, but until then let's take a quick look at some of the views that are available in RichTextKit.

* ``RichTextAlignmentPicker`` lets you pick text alignments. 
