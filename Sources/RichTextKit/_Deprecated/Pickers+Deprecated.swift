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
            selection: selection,
            values: alignments
        )
    }

    var alignments: [RichTextAlignment] { values }
}

public extension RichTextFontSizePicker {

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

@available(*, deprecated, renamed: "RichTextFontPicker")
public typealias FontPicker = RichTextFontPicker

@available(*, deprecated, renamed: "RichTextFontForEachPicker")
public typealias FontForEachPicker = RichTextFontForEachPicker

@available(*, deprecated, renamed: "RichTextFontListPicker")
public typealias FontListPicker = RichTextFontListPicker

@available(*, deprecated, renamed: "RichTextFontPickerFont")
public typealias FontPickerFont = RichTextFontPickerFont

@available(*, deprecated, renamed: "RichTextFontSizePicker")
public typealias FontSizePicker = RichTextFontSizePicker
