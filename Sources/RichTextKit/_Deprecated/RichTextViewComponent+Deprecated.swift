import Foundation

public extension RichTextViewComponent {
    
    @available(*, deprecated, message: "Use richTextFont?.fontName instead")
    var richTextFontName: String? {
        richTextFont?.fontName
    }

    @available(*, deprecated, message: "Use richTextFont?.pointSize instead")
    var richTextFontSize: CGFloat? {
        richTextFont?.pointSize
    }
    

    @available(*, deprecated, renamed: "currentColor(_:)")
    var currentBackgroundColor: ColorRepresentable? {
        currentColor(.background)
    }

    @available(*, deprecated, renamed: "currentColor(_:)")
    var currentForegroundColor: ColorRepresentable? {
        currentColor(.foreground)
    }

    @available(*, deprecated, renamed: "currentColor(_:)")
    var currentStrokeColor: ColorRepresentable? {
        currentColor(.stroke)
    }

    @available(*, deprecated, renamed: "currentColor(_:)")
    var currentStrikethroughColor: ColorRepresentable? {
        currentColor(.strikethrough)
    }

    @available(*, deprecated, renamed: "setCurrentColor(_:to:)")
    func setCurrentBackgroundColor(
        _ color: ColorRepresentable
    ) {
        setCurrentColor(.background, to: color)
    }

    @available(*, deprecated, renamed: "setCurrentColor(_:to:)")
    func setCurrentForegroundColor(
        _ color: ColorRepresentable
    ) {
        setCurrentColor(.foreground, to: color)
    }

    @available(*, deprecated, renamed: "setCurrentColor(_:to:)")
    func setCurrentStrokeColor(
        _ color: ColorRepresentable
    ) {
        setCurrentColor(.stroke, to: color)
    }

    @available(*, deprecated, renamed: "setCurrentColor(_:to:)")
    func setCurrentStrikethroughColor(
        _ color: ColorRepresentable
    ) {
        setCurrentColor(.strikethrough, to: color)
    }

    @available(*, deprecated, renamed: "currentTextAlignment")
    var currentRichTextAlignment: RichTextAlignment? {
        currentTextAlignment
    }

    @available(*, deprecated, renamed: "setCurrentTextAlignment(_:)")
    func setCurrentRichTextAlignment(
        to alignment: RichTextAlignment
    ) {
        setCurrentTextAlignment(alignment)
    }

    @available(*, deprecated, renamed: "setCurrentBackgroundColor(_:)")
    func setCurrentBackgroundColor(
        to color: ColorRepresentable
    ) {
        setCurrentBackgroundColor(color)
    }

    @available(*, deprecated, renamed: "setCurrentForegroundColor(_:)")
    func setCurrentForegroundColor(
        to color: ColorRepresentable
    ) {
        setCurrentForegroundColor(color)
    }

    @available(*, deprecated, renamed: "setCurrentFont(_:)")
    func setCurrentFont(to font: FontRepresentable) {
        setCurrentFont(font)
    }

    @available(*, deprecated, renamed: "setCurrentFontName(_:)")
    func setCurrentFontName(to name: String) {
        setCurrentFontName(name)
    }

    @available(*, deprecated, renamed: "setCurrentFontSize(_:)")
    func setCurrentFontSize(to size: CGFloat) {
        setCurrentFontSize(size)
    }

    @available(*, deprecated, message: "Use stepCurrentFontSize instead.")
    func decrementCurrentFontSize(points: UInt = 1) {
        stepCurrentFontSize(points: -Int(points))
    }

    @available(*, deprecated, message: "Use stepCurrentFontSize instead.")
    func incrementCurrentFontSize(points: UInt = 1) {
        stepCurrentFontSize(points: Int(points))
    }
}

public extension RichTextViewComponent {

    @available(*, deprecated, message: "richTextAttributes")
    var currentRichTextAttributes: RichTextAttributes {
        richTextAttributes
    }

    @available(*, deprecated, message: "richTextAttribute(_:)")
    func currentRichTextAttribute<Value>(_ attribute: RichTextAttribute) -> Value? {
        richTextAttributes[attribute] as? Value
    }

    @available(*, deprecated, message: "setRichTextAttribute(_:to:)")
    func setCurrentRichTextAttribute(_ attribute: RichTextAttribute, to value: Any) {
        setRichTextAttribute(attribute, to: value)
    }

    @available(*, deprecated, message: "setRichTextAttributes(_:)")
    func setCurrentRichTextAttributes(_ attributes: RichTextAttributes) {
        setRichTextAttributes(attributes)
    }


    @available(*, deprecated, message: "richTextAlignment")
    var currentTextAlignment: RichTextAlignment? {
        richTextAlignment
    }

    @available(*, deprecated, message: "setRichTextAlignment(_:)")
    func setCurrentTextAlignment(_ alignment: RichTextAlignment) {
        setRichTextAlignment(alignment)
    }


    @available(*, deprecated, message: "richTextColor(_:)")
    func currentColor(_ color: RichTextColor) -> ColorRepresentable? {
        richTextColor(color)
    }

    @available(*, deprecated, message: "setRichTextColor(_:to:)")
    func setCurrentColor(_ color: RichTextColor, to val: ColorRepresentable) {
        if currentColor(color) == val { return }
        guard let attribute = color.attribute else { return }
        setRichTextAttribute(attribute, to: val)
    }


    @available(*, deprecated, message: "richTextFont")
    var currentFont: FontRepresentable? {
        richTextFont
    }

    @available(*, deprecated, message: "Use richTextFont?.pointSize instead")
    var currentFontSize: CGFloat? {
        richTextFontSize
    }

    @available(*, deprecated, message: "Use richTextFont?.fontName instead")
    var currentFontName: String? {
        richTextFontName
    }

    @available(*, deprecated, message: "setRichTextFont(_:)")
    func setCurrentFont(_ font: FontRepresentable) {
        setRichTextFont(font)
    }

    @available(*, deprecated, message: "setRichTextFontName(_:)")
    func setCurrentFontName(_ name: String) {
        setRichTextFontName(name)
    }

    @available(*, deprecated, message: "setRichTextFontSize(_:)")
    func setCurrentFontSize(_ size: CGFloat) {
        setRichTextFontSize(size)
    }

    @available(*, deprecated, message: "stepRichTextFontSize(points:)")
    func stepCurrentFontSize(points: Int) {
        stepRichTextFontSize(points: points)
    }


    @available(*, deprecated, message: "richTextIndent")
    var currentIndent: CGFloat? {
        richTextIndent
    }

    @available(*, deprecated, message: "stepRichTextIndent(points:)")
    func stepCurrentIndent(
        points: CGFloat
    ) {
        stepRichTextIndent(points: points)
    }


    @available(*, deprecated, message: "richTextStyles")
    var currentRichTextStyles: [RichTextStyle] {
        richTextStyles
    }

    @available(*, deprecated, message: "setRichTextStyle(_:to:)")
    func setCurrentRichTextStyle(
        _ style: RichTextStyle,
        to newValue: Bool
    ) {
        setRichTextStyle(style, to: newValue)
    }
}
