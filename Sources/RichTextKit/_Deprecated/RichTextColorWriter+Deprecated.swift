import Foundation

public extension RichTextColorWriter {

    @available(*, deprecated, renamed: "setBackgroundColor(_:at:)")
    func setBackgroundColor(
        to color: ColorRepresentable,
        at range: NSRange? = nil
    ) {
        setBackgroundColor(color, at: range)
    }

    @available(*, deprecated, renamed: "setForegroundColor(_:at:)")
    func setForegroundColor(
        to color: ColorRepresentable,
        at range: NSRange? = nil
    ) {
        setForegroundColor(color, at: range)
    }
}
