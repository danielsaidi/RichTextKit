import SwiftUI

public extension RichTextContext {
    
    @available(*, deprecated, renamed: "decreaseFontSize(points:)")
    func decrementFontSize(points: UInt = 1) {
        stepFontSize(points: -Int(points))
    }
    
    @available(*, deprecated, renamed: "increaseFontSize(points:)")
    func incrementFontSize(points: UInt = 1) {
        stepFontSize(points: Int(points))
    }
}
