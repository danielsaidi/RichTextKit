import SwiftUI

@available(*, deprecated, renamed: "RichTextFormatToolbar")
public typealias RichTextFormatSheet = RichTextFormatToolbar

public extension RichTextFormatToolbar {
    
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
