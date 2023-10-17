import Foundation

@available(*, deprecated, message: "Use RichTextAttributeReader directly")
public protocol RichTextAlignmentReader: RichTextAttributeReader {}

@available(*, deprecated, message: "Use RichTextAttributeWriter directly")
public protocol RichTextAlignmentWriter: RichTextAttributeWriter {}

@available(*, deprecated, message: "Use RichTextAttributeReader directly")
public protocol RichTextColorWriter: RichTextAttributeWriter {}

@available(*, deprecated, message: "Use RichTextAttributeWriter directly")
public protocol RichTextColorReader: RichTextAttributeReader {}

@available(*, deprecated, message: "Use RichTextAttributeReader directly")
public protocol RichTextFontReader: RichTextAttributeReader {}

@available(*, deprecated, message: "Use RichTextAttributeWriter directly")
public protocol RichTextFontWriter: RichTextAttributeReader, RichTextAttributeWriter {}

@available(*, deprecated, message: "Use RichTextAttributeReader directly")
public protocol RichTextIndentReader: RichTextAttributeReader {}

@available(*, deprecated, message: "Use RichTextAttributeWriter directly")
public protocol RichTextIndentWriter: RichTextAttributeWriter {}

@available(*, deprecated, message: "Use RichTextAttributeReader directly")
public protocol RichTextStyleReader: RichTextAttributeReader {}

@available(*, deprecated, message: "Use RichTextAttributeWriter directly")
public protocol RichTextStyleWriter: RichTextAttributeWriter, RichTextStyleReader {}

public extension RichTextAttributeReader {
    
    @available(*, deprecated, renamed: "richTextBackgroundColor(at:)")
    func backgroundColor(
        at range: NSRange
    ) -> ColorRepresentable? {
        richTextAttribute(.backgroundColor, at: range)
    }
    
    @available(*, deprecated, renamed: "richTextForegroundColor(at:)")
    func foregroundColor(
        at range: NSRange
    ) -> ColorRepresentable? {
        richTextAttribute(.foregroundColor, at: range)
    }
    
    @available(*, deprecated, renamed: "richTextFont(at:)")
    func font(at range: NSRange) -> FontRepresentable? {
        richTextFont(at: range)
    }

    @available(*, deprecated, renamed: "richTextFontSize(at:)")
    func fontSize(at range: NSRange) -> CGFloat? {
        richTextFontSize(at: range)
    }
}

public extension RichTextAttributeWriter {
    
    @available(*, deprecated, renamed: "setRichTextBackgroundColor(_:at:)")
    func setBackgroundColor(
        to color: ColorRepresentable,
        at range: NSRange? = nil
    ) {
        setRichTextBackgroundColor(color, at: range)
    }
    
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

    @available(*, deprecated, renamed: "setRichTextForegroundColor(_:at:)")
    func setForegroundColor(
        to color: ColorRepresentable,
        at range: NSRange? = nil
    ) {
        setRichTextForegroundColor(color, at: range)
    }
    
    @available(*, deprecated, renamed: "setRichTextAlignment(_:at:)")
    func setRichTextAlignment(
        to alignment: RichTextAlignment,
        at range: NSRange
    ) {
        setRichTextAlignment(alignment, at: range)
    }
    
    @available(*, deprecated, renamed: "setRichTextFont(_:at:)")
    func setFont(
        _ font: FontRepresentable,
        at range: NSRange? = nil
    ) {
        setRichTextFont(font, at: range)
    }
    
    @available(*, deprecated, renamed: "setRichTextFontName(_:at:)")
    func setFontName(
        _ name: String,
        at range: NSRange? = nil
    ) {
        setRichTextFontName(name, at: range)
    }
    
    @available(*, deprecated, renamed: "setRichTextFontSize(_:at:)")
    func setFontSize(
        _ size: CGFloat,
        at range: NSRange? = nil
    ) {
        setRichTextFontSize(size, at: range)
    }
    
    @available(*, deprecated, renamed: "stepRichTextIndent(_:at:)")
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
    
    @available(*, deprecated, renamed: "stepRichTextFontSize(points:at:)")
    func stepFontSize(
        points: Int,
        at range: NSRange
    ) {
        stepRichTextFontSize(points: points, at: range)
    }
    
    @available(*, deprecated, message: "Use stepRichTextFontSize instead")
    func decrementFontSize(
        points: UInt = 1,
        at range: NSRange
    ) {
        stepRichTextFontSize(points: -Int(points), at: range)
    }

    @available(*, deprecated, message: "Use stepRichTextFontSize instead")
    func incrementFontSize(
        points: UInt = 1,
        at range: NSRange
    ) {
        stepRichTextFontSize(points: Int(points), at: range)
    }
}
