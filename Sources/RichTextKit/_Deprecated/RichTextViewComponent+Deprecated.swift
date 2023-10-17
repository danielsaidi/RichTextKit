import Foundation

public extension RichTextViewComponent {
    
    @available(*, deprecated, renamed: "curentTextAlignment")
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
