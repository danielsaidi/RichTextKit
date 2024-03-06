# Getting Started

This article describes how to get started with RichTextKit.

@Metadata {
    
    @PageImage(
        purpose: card,
        source: "Page",
        alt: "RichTextKit page icon"
    )
    
    @PageColor(blue)
}

RichTextKit is a Swift-based library that lets you work with rich text in UIKit, AppKit and SwiftUI. This article describes how to get started using RichTextKit in both SwiftUI, UIKit and AppKit.



## Getting started with SwiftUI

RichTextKit has a multi-platform SwiftUI ``RichTextEditor`` that can be added to any app:

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

The editor takes a text binding and a ``RichTextContext``, then uses an underlying ``RichTextCoordinator`` to sync changes between the context, the editor and the platform-specific text view that it wraps. 

You can use the ``RichTextContext`` to modify the text binding and its font, font size, colors, alignment etc. You can also observe the context properties, which change when you move the text input cursor.



## Getting started with UIKit & AppKit

RichTextKit is a SwiftUI focused SDK, but it builds upon the extended rich text support that it brings to both UIKit and AppKit, which you can use as standalone features as well.

RichTextKit defines a platform-specific RichTextView component, that inherits `UITextView` in UIKit and `NSTextView` in AppKit:

```swift
RichTextView(data: myData, format: .archivedData)  // Using data
RichTextView(string: myString, format: .plainText) // Using a string
```

These platform-specific views implement the ``RichTextViewComponent`` protocol to provide a lot more functionality than the native text views and bridge the platform-specific APIs to make the views behave more alike across platforms.

Although there are more UIKit and AppKit-specific functionality and tools in the library, the rest of this documentation will describe how it's used together with SwiftUI. 



## Fundamentals

RichTextKit use native terminology as much as possible, but has a couple of custom name conventions that may require explanation.

For instance, a ``RichTextReader`` lets you access an ``RichTextReader/attributedString`` (or its alias ``RichTextReader/richText``) while a ``RichTextWriter`` lets you access a mutable ``RichTextWriter/mutableAttributedString`` (or its alias ``RichTextWriter/mutableRichText``) that can be modified.

These protocols are specialized by more specific ones, like the ``RichTextAttributeReader`` and ``RichTextAttributeWriter``, which let you read and write attributes from and to the current rich text.

All these reader and writer protocols are implemented by various types. For instance `NSAttributedString` implements many reader protocols, while `NSMutableAttributedString` implements many writer protocols.

When using RichTextKit in SwiftUI, you should however only have to care about the ``RichTextEditor``, the ``RichTextContext`` and the many different <doc:Views-Article> that simplify building a great rich text-based app.  



## Context

The ``RichTextContext`` is at the heart of the ``RichTextEditor``. See the <doc:Context-Article> article for more information on how to use it to observe and change any rich text properties in your text editor.



## Data Formats

In RichTextKit, a ``RichTextDataFormat`` determines how rich text content is handled and persisted. See the <doc:Format-Article> article for more information on how to use different data formats.



## Views

There are many different SwiftUI views within the library besides the ``RichTextEditor``. See the <doc:Views-Article> article for more information.



## Further Reading

@Links(visualStyle: detailedGrid) {
    
    - <doc:Context-Article>
    - <doc:Format-Article>
    - <doc:Views-Article>
}
