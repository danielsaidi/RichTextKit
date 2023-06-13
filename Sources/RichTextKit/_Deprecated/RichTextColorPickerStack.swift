#if os(iOS) || os(macOS)
import SwiftUI

@available(*, deprecated, message: "This view is deprecated. Just add a set of RichTextColorPicker views in any stack instead.")
public struct RichTextColorPickerStack: View {

    public init(
        context: RichTextContext,
        colors: [RichTextColorPicker.PickerColor] = .all,
        spacing: Double = 20
    ) {
        self._context = ObservedObject(wrappedValue: context)
        self.colors = colors
        self.spacing = spacing
    }

    private let colors: [RichTextColorPicker.PickerColor]
    private let spacing: Double

    @ObservedObject
    private var context: RichTextContext

    public var body: some View {
        HStack(spacing: spacing) {
            ForEach(colors) {
                RichTextColorPicker(color: $0, context: context)
            }
        }
    }
}
#endif
