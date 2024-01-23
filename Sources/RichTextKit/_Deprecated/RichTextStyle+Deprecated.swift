import SwiftUI

@available(*, deprecated, renamed: "RichTextStyle.Button")
public typealias RichTextStyleButton = RichTextStyle.Button

@available(*, deprecated, renamed: "RichTextStyle.Toggle")
public typealias RichTextStyleToggle = RichTextStyle.Toggle

@available(*, deprecated, renamed: "RichTextStyle.ToggleGroup")
public typealias RichTextStyleToggleGroup = RichTextStyle.ToggleGroup

@available(*, deprecated, renamed: "RichTextStyle.ToggleStack")
public typealias RichTextStyleToggleStack = RichTextStyle.ToggleStack

public extension RichTextStyle.Button {
    
    @available(*, deprecated, message: "Use foregroundStyle and accentColor instead of style.")
    init(
        style: RichTextStyle,
        buttonStyle: Style = .standard,
        value: Binding<Bool>,
        fillVertically: Bool = false
    ) {
        self.init(
            style: style,
            value: value,
            fillVertically: fillVertically
        )
    }
    
    @available(*, deprecated, message: "Use foregroundStyle and accentColor instead of style.")
    init(
        style: RichTextStyle,
        buttonStyle: Style = .standard,
        context: RichTextContext,
        fillVertically: Bool = false
    ) {
        self.init(
            style: style,
            context: context,
            fillVertically: fillVertically
        )
    }
}

public extension RichTextStyle.Toggle {
    
    @available(*, deprecated, message: "Use foregroundStyle and tint instead of style.")
    init(
        style: RichTextStyle,
        buttonStyle: Style = .standard,
        value: Binding<Bool>,
        fillVertically: Bool = false
    ) {
        self.init(
            style: style,
            value: value,
            fillVertically: fillVertically
        )
    }
    
    @available(*, deprecated, message: "Use foregroundStyle and tint instead of style.")
    init(
        style: RichTextStyle,
        buttonStyle: Style = .standard,
        context: RichTextContext,
        fillVertically: Bool = false
    ) {
        self.init(
            style: style,
            context: context,
            fillVertically: fillVertically
        )
    }
}

public extension RichTextStyle.ToggleGroup {
    
    @available(*, deprecated, message: "Use foregroundStyle and tint instead of style.")
    init(
        context: RichTextContext,
        styles: [RichTextStyle] = .all,
        greedy: Bool = true,
        buttonStyle: RichTextStyle.Toggle.Style = .standard
    ) {
        self.init(
            context: context,
            styles: styles,
            greedy: greedy
        )
    }
}

public extension RichTextStyle.ToggleStack {
    
    @available(*, deprecated, message: "Use foregroundStyle and tint instead of style.")
    init(
        context: RichTextContext,
        styles: [RichTextStyle] = .all,
        buttonStyle: RichTextStyle.Toggle.Style = .standard,
        spacing: Double = 5
    ) {
        self.init(
            context: context,
            styles: styles,
            spacing: spacing
        )
    }
}

public extension RichTextStyle.Button {

    @available(*, deprecated, message: "Use foregroundStyle and accentColor instead of style.")
    struct Style {

        public init(
            inactiveColor: Color = .primary,
            activeColor: Color = .blue
        ) {
            self.inactiveColor = inactiveColor
            self.activeColor = activeColor
        }

        public var inactiveColor: Color

        public var activeColor: Color
    }
}

public extension RichTextStyle.Toggle {

    @available(*, deprecated, message: "Use foregroundStyle and tint instead of style.")
    struct Style {

        public init(
            inactiveColor: Color? = nil,
            activeColor: Color = .blue
        ) {
            self.inactiveColor = inactiveColor
            self.activeColor = activeColor
        }

        public var inactiveColor: Color?

        public var activeColor: Color
    }
}

@available(*, deprecated, message: "Use foregroundStyle and accentColor instead of style.")
public extension RichTextStyle.Button.Style {

    static var standard = RichTextStyle.Button.Style()
}

@available(*, deprecated, message: "Use foregroundStyle and tint instead of style.")
public extension RichTextStyle.Toggle.Style {

    static var standard = RichTextStyle.Toggle.Style()
}
