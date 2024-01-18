import SwiftUI

public extension RichTextAction {

    @available(*, deprecated, renamed: "increaseFontSize(points:)")
    static var incrementFontSize: RichTextAction { stepFontSize(points: 1) }

    @available(*, deprecated, renamed: "decreaseFontSize(points:)")
    static var decrementFontSize: RichTextAction { stepFontSize(points: -1) }

    @available(*, deprecated, renamed: "increaseFontSize(points:)")
    static var increaseFontSize: RichTextAction {
        increaseFontSize()
    }

    @available(*, deprecated, renamed: "decreaseFontSize(points:)")
    static var decreaseFontSize: RichTextAction {
        decreaseFontSize()
    }

    @available(*, deprecated, renamed: "increaseIndent(points:)")
    static var increaseIndent: RichTextAction {
        increaseIndent()
    }

    @available(*, deprecated, renamed: "decreaseIndent(points:)")
    static var decreaseIndent: RichTextAction {
        decreaseIndent()
    }

    @available(*, deprecated, renamed: "increaseSuperscript(steps:)")
    static var increaseSuperscript: RichTextAction {
        increaseSuperscript()
    }

    @available(*, deprecated, renamed: "decreaseSuperscript(steps:)")
    static var decreaseSuperscript: RichTextAction {
        decreaseSuperscript()
    }
}

@available(*, deprecated, renamed: "RichTextAction.Button")
public typealias RichTextActionButton = RichTextAction.Button

#if iOS || macOS || os(visionOS)
@available(*, deprecated, renamed: "RichTextAction.ButtonGroup")
public typealias RichTextActionButtonGroup = RichTextAction.ButtonGroup
#endif

@available(*, deprecated, renamed: "RichTextAction.ButtonStack")
public typealias RichTextActionButtonStack = RichTextAction.ButtonStack
