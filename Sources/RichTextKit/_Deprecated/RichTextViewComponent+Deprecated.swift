import Foundation

public extension RichTextViewComponent {
    
    
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
