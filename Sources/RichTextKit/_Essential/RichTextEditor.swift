#if iOS || macOS || os(tvOS) || os(visionOS)
import SwiftUI

/// This view can be used to view and edit rich text in SwiftUI.
///
/// Thos view wraps a platform-specific ``RichTextView`` with an observable
/// ``RichTextContext`` and a ``RichTextCoordinator`` that is used
/// to keep the view and context in sync.
///
/// You can use the provided context to trigger and observe changes to the editor.
/// Note that changing the value of the `text` binding will not update the editor.
/// Until it is fixed, use `setAttributedString(to:)`.
///
/// Since the view wraps a native `UIKit` or `AppKit` view, you can't use the
/// `.toolbar` modifier on it, like you can with other SwiftUI views. This means
/// that this doesn't work:
///
/// ```swift
/// RichTextEditor(text: $text, context: context)
///     .toolbar {
///         ToolbarItemGroup(placement: .keyboard) { .... }
///     }
/// ```
///
/// This will not show a keyboard toolbar, since the modifier has no effect. To work
/// around this limitation, use a ``RichTextKeyboardToolbar`` instead.
///
/// You can configure and style the view by applying config and style modifiers to
/// your view hierarchy:
///
/// ```swift
/// VStack {
///     RichTextEditor(...)
///     ...
/// }
/// .richTextEditorStyle(...)
/// .richTextEditorConfig(...)
/// ```
///
/// For more information, see ``RichTextKeyboardToolbarConfig`` and
/// ``RichTextKeyboardToolbarStyle``.
public struct RichTextEditor: ViewRepresentable {



    @Environment(\.richTextEditorConfig)
    private var config

    @Environment(\.richTextEditorStyle)
    private var style

    #if iOS || os(tvOS) || os(visionOS)
    public let textView = RichTextView()
    #endif

    #if macOS
    public let scrollView = RichTextView.scrollableTextView()

    public var textView: RichTextView {
        scrollView.hasVerticalScroller = config.isScrollBarsVisible
        return scrollView.documentView as? RichTextView ?? RichTextView()
    }
    #endif


    #if iOS || os(tvOS) || os(visionOS)
    

    #else

    public func makeNSView(context: Context) -> some NSView {
        textView.setup(with: text.wrappedValue, format: format)
        textView.configuration = config
        textView.theme = style
        viewConfiguration(textView)
        return scrollView
    }

    public func updateNSView(_ view: NSViewType, context: Context) {}
    #endif
}

// MARK: RichTextPresenter

public extension RichTextEditor {

    /// Get the currently selected range.
    var selectedRange: NSRange {
        textView.selectedRange
    }
}

// MARK: RichTextReader

public extension RichTextEditor {

    /// Get the string that is managed by the editor.
    var attributedString: NSAttributedString {
        text.wrappedValue
    }
}

// MARK: RichTextWriter

public extension RichTextEditor {

    /// Get the mutable string that is managed by the editor.
    var mutableAttributedString: NSMutableAttributedString? {
        textView.mutableAttributedString
    }
}
#endif
