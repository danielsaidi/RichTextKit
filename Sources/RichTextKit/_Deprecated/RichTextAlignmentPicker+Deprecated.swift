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
            selection: selection)
    }

    var alignments: [RichTextAlignment] { values }
}
