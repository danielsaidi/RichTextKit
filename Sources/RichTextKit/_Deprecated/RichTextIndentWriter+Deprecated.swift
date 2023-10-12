import Foundation

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

public extension RichTextIndentWriter {

    @available(*, deprecated, renamed: "setRichTextIndent(_:at:)")
    func setRichTextIndent(
        to indent: RichTextIndent,
        at range: NSRange
    ) -> RichTextAttributes? {
        let increase = indent == .increase
        let change: CGFloat = 30.0
        let points = increase ? change : -change
        return stepRichTextIndent(
            points: points,
            at: range
        )
    }
}
