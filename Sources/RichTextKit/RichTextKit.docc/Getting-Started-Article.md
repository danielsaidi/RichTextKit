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

RichTextKit is a Swift-based library that lets you work with rich text in UIKit, AppKit and SwiftUI. This article describes how to get started.



## Getting started with SwiftUI

RichTextKit has a multi-platform SwiftUI ``RichTextEditor`` that can be used to edit rich text:

```swift
struct MyView: View {

    @State
    private var text = NSAttributedString(string: "Type text here...")
    // You can also load attributed strings from data, documents, etc. 
    
    @StateObject
    var context = RichTextContext()

    var body: some View {
        RichTextEditor(text: $text, context: context) {
            // You can customize the native text view here
        }
    }
}
```

The ``RichTextEditor`` takes a text binding and a ``RichTextContext`` (which can be used to edit the text), then wraps a ``RichTextView`` (described further down) and uses a ``RichTextCoordinator`` to sync changes between the context, editor and view.

If you just want to view a text, you can use a ``RichTextViewer`` instead. It just presents the text in an read-only ``RichTextEditor``:

```swift
struct MyView: View {

    private var text = NSAttributedString(...)

    var body: some View {
        RichTextViewer(text: text)
    }
}
```

RichTextKit comes with a bunch of UI components, keyboard shortcuts & menu commands that make it easy to build a rich text editor.



## Getting started with UIKit & AppKit

RichTextKit is a SwiftUI-focused SDK, but builds upon the extended rich text support it brings to both UIKit and AppKit (which you can use as standalone features as well).

RichTextKit defines a platform-specific ``RichTextView`` component that inherits `UITextView` in UIKit and `NSTextView` in AppKit:

```swift
RichTextView(data: myData, format: .archivedData)  // Using data
RichTextView(string: myString, format: .plainText) // Using a string
```

Both views implement the ``RichTextViewComponent`` protocol to get a lot more functionality and bridge the platform-specific APIs. 



## Fundamentals

RichTextKit use native terminology as much as possible, but has some custom name conventions that may require explanation.

For instance, a ``RichTextReader`` lets you access an ``RichTextReader/attributedString`` (or its alias ``RichTextReader/richText``) while a ``RichTextWriter`` lets you access a mutable ``RichTextWriter/mutableAttributedString`` (or its alias ``RichTextWriter/mutableRichText``).

These protocols are specialized by more specific ones, like the ``RichTextAttributeReader`` and ``RichTextAttributeWriter``, which let you read and write attributes in a rich text value.

These reader and writer protocols are already implemented by various types. For instance ``Foundation/NSAttributedString`` implements many reader protocols, while ``Foundation/NSMutableAttributedString`` implements many writer protocols.

When using RichTextKit in SwiftUI, you should however mainly focus on the ``RichTextEditor``, the ``RichTextContext`` and all the various <doc:Views-Article> that simplify building a great rich text-based app.  



## Context

The ``RichTextContext`` is at the heart of the ``RichTextEditor``. See the <doc:Context-Article> article for more information on how to use it to observe and change any rich text properties in your text editor.



## Data Formats

In RichTextKit, a ``RichTextDataFormat`` determines how rich text content is handled and persisted. See the <doc:Format-Article> article for more information on how to use different data formats.



## Views & Components

There are many different SwiftUI views within the library besides the ``RichTextEditor``. See the <doc:Views-Article> article for more information.



## Further Reading

@Links(visualStyle: detailedGrid) {
    
    - <doc:Context-Article>
    - <doc:Format-Article>
    - <doc:Views-Article>
}
