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

    public init() {}


    /**
     The current text alignment, if any.
     */
    @Published
    public var alignment: RichTextAlignment = .left

    /**
     The current font, if any.
     */
    @Published
    public var font: FontRepresentable? = nil

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
}
