import SwiftUI

public extension RichTextAction {
    
    @available(*, deprecated, renamed: "increaseFontSize")
    static var incrementFontSize: RichTextAction { stepFontSize(points: 1) }

    @available(*, deprecated, renamed: "decreaseFontSize")
    static var decrementFontSize: RichTextAction { stepFontSize(points: -1) }
}
