import CoreGraphics
import Foundation

public extension RichTextFontWriter {

    @available(*, deprecated, renamed: "setFont(_:at:)")
    func setFont(
        to font: FontRepresentable,
        at range: NSRange? = nil
    ) {
        setFont(font, at: range)
    }

    @available(*, deprecated, renamed: "setFontName(_:at:)")
    func setFontName(
        to name: String,
        at range: NSRange? = nil
    ) {
        setFontName(name, at: range)
    }

    @available(*, deprecated, renamed: "setFontSize(_:at:)")
    func setFontSize(
        to size: CGFloat,
        at range: NSRange? = nil
    ) {
        setFontSize(size, at: range)
    }
}
