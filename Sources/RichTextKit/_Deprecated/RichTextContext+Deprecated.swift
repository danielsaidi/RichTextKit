#if os(iOS) || os(macOS) || os(tvOS)
import SwiftUI

public extension RichTextContext {

    @available(*, deprecated, renamed: "highlightingStyle")
    var standardHighlightingStyle: RichTextHighlightingStyle { highlightingStyle }

    @available(*, deprecated, renamed: "textAlignment")
    var alignment: RichTextAlignment {
        get { textAlignment }
        set { textAlignment = newValue }
    }
}
#endif
