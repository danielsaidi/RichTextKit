#if os(iOS) || os(macOS) || os(tvOS)
import SwiftUI

public extension RichTextContext {

    @available(*, deprecated, renamed: "highlightingStyle")
    var standardHighlightingStyle: RichTextHighlightingStyle { highlightingStyle }
}
#endif
