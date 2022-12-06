#if os(iOS) || os(macOS) || os(tvOS)
import SwiftUI

public extension RichTextCoordinator {

    @available(*, deprecated, message: "Use the richTextContext initializer instead")
    convenience init(
        text: Binding<NSAttributedString>,
        textView: RichTextView,
        context: RichTextContext
    ) {
        self.init(
            text: text,
            textView: textView,
            richTextContext: context)
    }

    @available(*, deprecated, renamed: "richTextContext")
    var context: RichTextContext { richTextContext }
}
#endif
