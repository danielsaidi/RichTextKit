//
//  EditorTopToolbar.swift
//  Demo (iOS)
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
            fontPicker(for: $context.fontName)
            Spacer()
            sizeTools(for: $context.fontSize)
        }
    }
}

struct EditorTopToolbar_Previews: PreviewProvider {
    static var previews: some View {
        EditorTopToolbar()
    }
}
