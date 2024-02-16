#if iOS || macOS || os(visionOS)
import SwiftUI

public extension RichTextFormatSheet {

    @available(*, deprecated, message: "Use the config initializer instead.")
    init(
        context: RichTextContext,
        colorPickers: [RichTextColor]
    ) {
        self.init(
            context: context,
            config: .init(colorPickers: colorPickers)
        )
    }
}

public extension RichTextFormatSidebar {

    @available(*, deprecated, message: "Use the config initializer instead.")
    init(
        context: RichTextContext,
        colorPickers: [RichTextColor] = [.foreground, .background]
    ) {
        self.init(
            context: context,
            config: .init(colorPickers: colorPickers)
        )
    }
}
#endif
