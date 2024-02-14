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
    
    @available(*, deprecated, message: "Use handle(_:) with the .pasteImage action")
    func pasteImage(
        _ image: ImageRepresentable,
        at index: Int? = nil,
        moveCursorToPastedContent: Bool = false
    ) {
        let index = index ?? selectedRange.location
        userActionPublisher.send(
            .pasteImage(
                RichTextInsertion(
                    content: image,
                    at: index,
                    moveCursor: moveCursorToPastedContent
                )
            )
        )
    }

    @available(*, deprecated, message: "Use handle(_:) with the .pasteImages action")
    func pasteImages(
        _ images: [ImageRepresentable],
        at index: Int? = nil,
        moveCursorToPastedContent: Bool = false
    ) {
        let index = index ?? selectedRange.location
        userActionPublisher.send(
            .pasteImages(
                RichTextInsertion(
                    content: images,
                    at: index,
                    moveCursor: moveCursorToPastedContent
                )
            )
        )
    }

    @available(*, deprecated, message: "Use handle(_:) with the .pasteText action")
    func pasteText(
        _ text: String,
        at index: Int? = nil,
        moveCursorToPastedContent: Bool = false
    ) {
        let index = index ?? selectedRange.location
        userActionPublisher.send(
            .pasteText(
                RichTextInsertion(
                    content: text,
                    at: index,
                    moveCursor: moveCursorToPastedContent
                )
            )
        )
    }
}
