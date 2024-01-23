import Foundation

public extension RichTextAttributeReader {

    @available(*, deprecated, message: "Use richTextFont(at:)?.fontName instead")
    func richTextFontName(
        at range: NSRange
    ) -> String? {
        richTextFont(at: range)?.fontName
    }

    @available(*, deprecated, message: "Use richTextFont(at:)?.pointSize instead")
    func richTextFontSize(
        at range: NSRange
    ) -> CGFloat? {
        richTextFont(at: range)?.pointSize
    }

    @available(*, deprecated, renamed: "richTextColor(_:at:)")
    func richTextBackgroundColor(
        at range: NSRange
    ) -> ColorRepresentable? {
        richTextAttribute(.backgroundColor, at: range)
    }

    @available(*, deprecated, renamed: "richTextColor(_:at:)")
    func richTextForegroundColor(
        at range: NSRange
    ) -> ColorRepresentable? {
        richTextAttribute(.foregroundColor, at: range)
    }

    @available(*, deprecated, renamed: "richTextColor(_:at:)")
    func richTextStrikethroughColor(
        at range: NSRange
    ) -> ColorRepresentable? {
        richTextAttribute(.strikethroughColor, at: range)
    }

    @available(*, deprecated, renamed: "richTextColor(_:at:)")
    func richTextStrokeColor(
        at range: NSRange
    ) -> ColorRepresentable? {
        richTextAttribute(.strokeColor, at: range)
    }

    @available(*, deprecated, renamed: "richTextColor(_:at:)")
    func richTextUnderlineColor(
        at range: NSRange
    ) -> ColorRepresentable? {
        richTextAttribute(.underlineColor, at: range)
    }
}
