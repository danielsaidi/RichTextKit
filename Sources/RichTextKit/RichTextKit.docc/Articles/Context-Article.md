# Rich Text Context

This article describes how to use the ``RichTextContext`` to observe and modify rich text.

@Metadata {
    
    @PageImage(
        purpose: card,
        source: "Page",
        alt: "RichTextKit page icon"
    )
    
    @PageColor(blue)
}

The ``RichTextContext`` is at the heart of the ``RichTextEditor``. It can be used to observe and modify the rich text in the editor and to trigger rich text-specific ``RichTextAction``s and other functions.


## How to observe context changes

When you move the text cursor around in a ``RichTextEditor``, its ``RichTextCoordinator`` will sync the ``RichTextContext`` with the current state of the editor.

This means that if you move the text input cursor to a piece of code that has bold enabled, the context's ``RichTextContext/styles`` property will update to indicate that ``RichTextStyle/bold`` is enabled.

In this code example, the text above the editor will automatically update to show the current bold state when moving the text cursor:

```swift
struct MyView: View {

    @State
    private var text = NSAttributedString(string: "")
    
    @StateObject
    var context = RichTextContext()

    var body: some View {
        VStack {
            Text("Is bold: \(isBoldActive)")
            RichTextEditor(
                text: $text, 
                context: context
            )
        }
    }

    var isBoldActive: Bool {
        context.styles.hasStyle(.bold)
    }
}
```

You can use these capabilities to help drive the state of your UI as the editor context changes.



## How to use the context to modify the rich text

You can modify the rich text by using the ``RichTextContext`` to trigger certain ``RichTextAction``s or call certain context functions.

For instance, in this code, tapping the button will increase the font size of the currently selected text:

```swift
struct MyView: View {

    @State
    private var text = NSAttributedString(string: "")
    
    @StateObject
    var context = RichTextContext()

    var body: some View {
        VStack {
            Button("Increase font size") {
                context.trigger(.stepFontSize(points: 1))
            }
            RichTextEditor(
                text: $text, 
                context: context
            )
        }
    }
}
```

You can also call other context functions. For instance ``RichTextContext/paste(_:)`` is a shorthand to not have to call the ``RichTextContext/trigger(_:)`` function with ``RichTextAction/pasteText(_:)`` or the other paste actions.

However, most rich text operations in RichTextKit can be triggered with a ``RichTextAction``, which means that ``RichTextContext/trigger(_:)`` can be used to perform most (but not all) operations.    

Have a look at the context documentation for more information.
