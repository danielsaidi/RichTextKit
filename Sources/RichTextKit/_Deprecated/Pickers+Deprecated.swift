import SwiftUI

public extension RichTextAlignmentPicker {

    @available(*, deprecated, message: "Use the values initializer instead.")
    init(
        title: String = "",
        alignments: [RichTextAlignment],
        selection: Binding<RichTextAlignment>
    ) {
        self.init(
            title: title,
            values: alignments,
            selection: selection
        )
    }

    var alignments: [RichTextAlignment] { values }
}


public extension FontSizePicker {

    @available(*, deprecated, message: "Use the values initializer instead.")
    init(
        selection: Binding<CGFloat>,
        sizes: [CGFloat]
    ) {
        self.init(
            selection: selection,
            values: sizes
        )
    }
}
