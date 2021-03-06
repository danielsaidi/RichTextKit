//
//  EditorTopToolbar.swift
//  Demo (macOS)
//
//  Created by Daniel Saidi on 2022-06-06.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import RichTextKit
import SwiftUI

struct EditorTopToolbar: View, DemoToolbar {

    @EnvironmentObject
    var context: RichTextContext

    var body: some View {
        HStack {
            fontItems
            divider
            styleButtons
            divider
            alignmentPicker(for: $context.alignment)
            divider
            colorPickers
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 7)
        .background(Color.white.opacity(0.1))
    }
}

private extension EditorTopToolbar {

    @ViewBuilder
    var fontItems: some View {
        fontPicker(for: $context.fontName)
        divider
        sizeTools(for: $context.fontSize)
    }
}

struct EditorTopToolbar_Previews: PreviewProvider {
    static var previews: some View {
        EditorTopToolbar()
            .environmentObject(RichTextContext())
    }
}
