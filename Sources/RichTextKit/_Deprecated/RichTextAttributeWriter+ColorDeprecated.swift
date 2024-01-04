import Foundation

public extension RichTextAttributeWriter {

    @available(*, deprecated, renamed: "setRichTextColor(_:to:at:)")
    func setRichTextBackgroundColor(
        _ color: ColorRepresentable,
        at range: NSRange? = nil
    ) {
        setRichTextAttribute(.backgroundColor, to: color, at: range)
    }

    @available(*, deprecated, renamed: "setRichTextColor(_:to:at:)")
    func setRichTextForegroundColor(
        _ color: ColorRepresentable,
        at range: NSRange? = nil
    ) {
        setRichTextAttribute(.foregroundColor, to: color, at: range)
    }

    @available(*, deprecated, renamed: "setRichTextColor(_:to:at:)")
    func setRichTextStrikethroughColor(
        _ color: ColorRepresentable,
        at range: NSRange? = nil
    ) {
        setRichTextAttribute(.strikethroughColor, to: color, at: range)
    }

    @available(*, deprecated, renamed: "setRichTextColor(_:to:at:)")
    func setRichTextStrokeColor(
        _ color: ColorRepresentable,
        at range: NSRange? = nil
    ) {
        setRichTextAttribute(.strokeColor, to: color, at: range)
    }
}
