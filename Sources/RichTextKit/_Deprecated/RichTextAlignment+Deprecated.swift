import SwiftUI

@available(*, deprecated, renamed: "RichTextAlignment.Picker")
public typealias RichTextAlignmentPicker = RichTextAlignment.Picker

public extension RichTextAlignment.Picker.Style {
    
    @available(*, deprecated, renamed: "init(lightIconColor:darkIconColor:)")
    init(iconColor: Color = .primary) {
        self.lightIconColor = iconColor
        self.darkIconColor = iconColor
    }
}
