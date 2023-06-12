# Getting Started

RichTextKit is a Swift-based library that lets you work with rich text in UIKit, AppKit and SwiftUI.



## SwiftUI

RichTextKit has a SwiftUI ``RichTextEditor``, which takes a text binding and a ``RichTextContext``:

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

The editor uses a ``RichTextCoordinator`` to sync changes between the context, the editor and the underlying, platform-specific view. 

You can now use the context to change the text binding and its font, font size, colors, alignment etc. You can also use the context to observe how these properties change, for instance when you move the text input cursor.

For instance, to display and change the current font size, you can use the context's ``RichTextContext/fontSize``:

```swift
Button("Set font size") {
    context.fontSize = 123
}
.onChange(of: context.fontSize) {
    print("The current font size is \(context.fontSize)")
}
```

This means that you can observe and act on any property changes in the context with plain SwiftUI events.



## UIKit and AppKit

In UIKit and AppKit, you can create a ``RichTextView`` view instead of a `UITextView` or `NSTextView`:

```swift
RichTextView(data: myData, format: .archivedData)  // Using data
RichTextView(string: myString, format: .plainText) // Using a string
```

You can also initialize the it without specifying a string or data, and set it up with a string or data later:

```swift
view.setup(with: "A rich text", format: .archivedData)
```

`RichTextView` has a lot more functionality than the native views and bridges the platform-specific api:s so that the views behave more alike across platforms.



## Additional functionality

Other than these views, RichTextKit has a bunch of additional functionality to native types, to simplify working with rich text attrbutes, styles, fonts, text alignments, image attachments etc. It uses extensions and protocols to unify native and library types and has pickers, menus, toolbars etc. to help you build a great rich text editor. 



## Rich Text Format

In RichTextKit, the ``RichTextDataFormat`` determines how the rich text content is handled:

* `.archivedData` uses an `NSKeyedArchiver` to persist rich text and image attachments into the text itself, and an `NSKeyedUnarchiver` to parse any archived strings.
* `.rtf` supports rich content but requires additional handling of images.
* `.plainText` only supports plain text without formatting.
* `.vendorArchivedData` extends `.archivedData` with vendor-specific information, which you can use if you need to use your own uniform types.

Archived data is very capable, but is not as portable as the other formats. For instance, it may be hard to use on other platforms.

RichTextKit adds an `NSAttributedString` initializer for initializing a rich text with data, for instance:

```
NSAttributedString(data: myData, format: .archivedData)
```

You can use the ``RichTextDataReader`` protocol (which is implemented by `NSAttributedString` and other types in the library) to get data for various formats:

```
let data = richText.data(for: .archivedData)
```

The various views in the library uses this initializer and data function, but you can use them as is as well.



## SwiftUI views

This will eventually be a separate article, but until then let's take a quick look at some of the views that are available in RichTextKit.

### Actions

* ``RichTextActionButton``
* ``RichTextActionButtonGroup``
* ``RichTextActionButtonStack``

### Alignment

* ``RichTextAlignmentPicker``

### Data

* ``RichTextDataFormatMenu``

### Export

* ``RichTextExportMenu``

### Formatting

* ``RichTextFormatSheet``
* ``RichTextFormatSidebar``

### Keyboard

* ``RichTextKeyboardToolbar``
* ``RichTextKeyboardToolbarMenu``

### Colors

* ``RichTextColorPicker`` 
* ``RichTextColorPickerStack``

### Fonts

* ``RichTextFontPicker``
* ``RichTextFontForEachPicker``
* ``RichTextFontListPicker``
* ``RichTextFontSizePicker``
* ``RichTextFontSizePickerStack``

### Sharing

* ``RichTextShareMenu``

### Styles

* ``RichTextStyleButton``
* ``RichTextStyleToggle``
* ``RichTextStyleToggleGroup``
* ``RichTextStyleToggleStack``

Have a look at the demo apps for some ways that you can use these views.  



## Terminology

RichTextKit tries to use native terminology as much as possible, but has a couple of custom name conventions that may require some explanation.

In RichTextKit, a `reader` is anything that can access (or read) certain information, while a `writer` is anything that can modify certain information.

For instance, the ``RichTextReader`` lets you access the current ``RichTextReader/attributedString`` (or its alias ``RichTextReader/richText``) while the ``RichTextWriter`` lets you access a mutable ``RichTextWriter/mutableAttributedString`` (or its alias ``RichTextWriter/mutableRichText``).

These base protocols are then specialized by more specific protocols, like the ``RichTextAttributeReader`` and ``RichTextAttributeWriter`` protocols which let you read and write attributes from and to the current rich text.

All these reader and writer protocols are implemented by various types. For instance `NSAttributedString` implements many reader protocols, while `NSMutableAttributedString` implements many writer protocols.
