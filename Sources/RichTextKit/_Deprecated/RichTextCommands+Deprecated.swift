import SwiftUI

@available(*, deprecated, renamed: "RichTextCommand.ActionButton")
public typealias RichTextCommandButton = RichTextCommand.ActionButton

@available(*, deprecated, renamed: "RichTextCommand.ActionButtonGroup")
public typealias RichTextCommandButtonGroup = RichTextCommand.ActionButtonGroup

@available(*, deprecated, renamed: "RichTextCommand.AlignmentOptionsGroup")
public typealias RichTextCommandsAlignmentOptionsGroup = RichTextCommand.AlignmentOptionsGroup

@available(*, deprecated, renamed: "RichTextCommand.FontSizeOptionsGroup")
public typealias RichTextCommandsFontSizeOptionsGroup = RichTextCommand.FontSizeOptionsGroup

@available(*, deprecated, renamed: "RichTextCommand.IndentOptionsGroup")
public typealias RichTextCommandsIndentOptionsGroup = RichTextCommand.IndentOptionsGroup

@available(*, deprecated, renamed: "RichTextCommand.StyleOptionsGroup")
public typealias RichTextCommandsStyleOptionsGroup = RichTextCommand.StyleOptionsGroup

#if iOS || macOS || os(visionOS)
@available(*, deprecated, renamed: "RichTextCommand.FormatMenu")
public typealias RichTextFormatCommandMenu = RichTextCommand.FormatMenu

@available(*, deprecated, renamed: "RichTextCommand.ShareMenu")
public typealias RichTextShareCommandMenu = RichTextCommand.ShareMenu
#endif
