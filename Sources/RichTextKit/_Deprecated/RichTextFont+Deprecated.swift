import SwiftUI

@available(*, deprecated, renamed: "RichTextFont.Picker")
public typealias RichTextFontPicker = RichTextFont.Picker

@available(*, deprecated, renamed: "RichTextFont.ForEachPicker")
public typealias RichTextFontForEachPicker = RichTextFont.ForEachPicker

@available(*, deprecated, renamed: "RichTextFont.ListPicker")
public typealias RichTextFontListPicker = RichTextFont.ListPicker

@available(*, deprecated, renamed: "RichTextFont.PickerFont")
public typealias RichTextFontPickerFont = RichTextFont.PickerFont

@available(*, deprecated, renamed: "RichTextFont.SizePicker")
public typealias RichTextFontSizePicker = RichTextFont.SizePicker

#if iOS || macOS || os(visionOS)
@available(*, deprecated, renamed: "RichTextFont.SizePickerStack")
public typealias RichTextFontSizePickerStack = RichTextFont.SizePickerStack
#endif

public extension RichTextFont.SizePicker {
    
    @available(*, deprecated, renamed: "standardValues")
    static var standardFontSizes: [CGFloat] {
        standardValues
    }
    
    @available(*, deprecated, renamed: "values(for:selection:)")
    static func fontSizePickerSizes(
        for sizes: [CGFloat],
        selection: CGFloat
    ) -> [CGFloat] {
        values(for: sizes, selection: selection)
    }
}
