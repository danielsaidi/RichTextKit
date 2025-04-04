import Foundation

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
#endif

public extension RichTextViewComponent {

    @available(*, deprecated, message: "Use richTextParagraphStyleValue(\\.alignment) instead.")
    var richTextAlignment: RichTextAlignment? {
        guard let val = richTextParagraphStyleValue(\.alignment) else { return nil }
        return RichTextAlignment(val)
    }

    @available(*, deprecated, message: "Use setRichTextParagraphStyleValue(\\.alignment, ...) instead.")
    /// Set the text alignment.
    func setRichTextAlignment(_ alignment: RichTextAlignment) {
        if richTextAlignment == alignment { return }
        let style = NSMutableParagraphStyle(
            from: richTextParagraphStyle,
            alignment: alignment
        )
        setRichTextParagraphStyle(style)
    }
}
