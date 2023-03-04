//
//  RichTextCommandsTabOptionsGroup.swift
//  RichTextKit
//
//  Created by James Bradley on 2023-03-04.
//  Copyright © 2023 James Bradley. All rights reserved.
//

import SwiftUI

/**
 This view can be added to a `Commands`, to expose rich text
 alignment menu options to an app main menu or key commands.
 */
public struct RichTextCommandsTabOptionsGroup: View {

    public init() {}

    @FocusedValue(\.richTextContext)
    private var context: RichTextContext?

    public var body: some View {
        Button(RTKL10n.tab.text) {
            context?.textTab = .single
        }
    }
}
