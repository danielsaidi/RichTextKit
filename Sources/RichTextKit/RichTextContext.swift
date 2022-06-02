//
//  RichTextContext.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-22.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This context can be used to observe state for any rich text
 editor, as well as other properties.

 SwiftUI can observe the published properties to keep the UI
 of an app in sync, while a coordinator can subscribe to any
 property to keep a wrapped text view in sync.
 */
public class RichTextContext: ObservableObject {

    /**
     Create a new rich text context.

     - Parameters:
       - standardFontSize: The font size to use by default.
     */
    public init(
        standardFontSize: CGFloat = .standardRichTextFontSize
    ) {
        self.fontSize = standardFontSize
    }


    // MARK: - Bindings

    /**
     A custom binding that can be used to set the background
     color with e.g. a SwitUI `ColorPicker`.
     */
    public var backgroundColorBinding: Binding<Color> {
        Binding(
            get: { Color(self.backgroundColor ?? .clear) },
            set: { self.backgroundColor = ColorRepresentable($0)}
        )
    }


    // MARK: - Properties

    /**
     The current text alignment, if any.
     */
    @Published
    public var alignment: RichTextAlignment = .left

    /**
     The current background color, if any.
     */
    @Published
    public var backgroundColor: ColorRepresentable? = nil

    /**
     The current font name.
     */
    @Published
    public var fontName = ""

    /**
     The current font size.
     */
    @Published
    public var fontSize: CGFloat

    /**
     The current foreground color, if any.
     */
    @Published
    public var foregroundColor: ColorRepresentable? = nil

    /**
     A custom binding that can be used to set the foreground
     color with e.g. a SwitUI `ColorPicker`.
     */
    public var foregroundColorBinding: Binding<Color> {
        Binding(
            get: { Color(self.foregroundColor ?? .clear) },
            set: { self.foregroundColor = ColorRepresentable($0)}
        )
    }

    /**
     Whether or not the current text is bold.
     */
    @Published
    public var isBold = false

    /**
     Whether or not the rich text is currently being edited.
     */
    @Published
    public var isEditingText = false

    /**
     Whether or not the current text is italic.
     */
    @Published
    public var isItalic = false

    /**
     Whether or not the current text is underlined.
     */
    @Published
    public var isUnderlined = false

    /**
     Whether or not to undo the latest change.
     */
    @Published
    public var shouldUndoLatestChange = false

    /**
     Whether or not to redo the latest undone change.
     */
    @Published
    public var shouldRedoLatestChange = false
}

public extension RichTextContext {

    /**
     Check whether or not a certain style is enabled.
     */
    func hasStyle(_ style: RichTextStyle) -> Bool {
        switch style {
        case .bold: return isBold
        case .italic: return isItalic
        case .underlined: return isUnderlined
        }
    }

    /**
     Redo the latest undone change.
     */
    func redoLatestChange() {
        shouldRedoLatestChange = true
    }

    /**
     Toggle a certain rich text style.
     */
    func toggle(_ style: RichTextStyle) {
        switch style {
        case .bold: isBold.toggle()
        case .italic: isItalic.toggle()
        case .underlined: isUnderlined.toggle()
        }
    }

    /**
     Toggle whether or not the text is being edited.
     */
    func toggleIsEditing() {
        isEditingText.toggle()
    }

    /**
     Undo the latest change.
     */
    func undoLatestChange() {
        shouldUndoLatestChange = true
    }
}
