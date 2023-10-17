import SwiftUI

public extension RichTextContext {
    
    @available(*, deprecated, message: "Use handle(_:) instead")
    func decrementFontSize(points: UInt = 1) {
        handle(.decreaseFontSize(points: points))
    }
    
    @available(*, deprecated, message: "Use handle(_:) instead")
    func incrementFontSize(points: UInt = 1) {
        handle(.increaseFontSize(points: points))
    }
    
    @available(*, deprecated, message: "Use handle(_:) instead")
    func increaseFontSize(points: UInt = 1) {
        handle(.increaseFontSize(points: points))
    }
    
    @available(*, deprecated, message: "Use handle(_:) instead")
    func decreaseFontSize(points: UInt = 1) {
        handle(.decreaseFontSize(points: points))
    }
    
    @available(*, deprecated, message: "Use handle(_:) instead")
    func increaseIndent(points: UInt = 1) {
        handle(.increaseIndent(points: points))
    }
    
    @available(*, deprecated, message: "Use handle(_:) instead")
    func decreaseIndent(points: UInt = 1) {
        handle(.decreaseIndent(points: points))
    }
}
