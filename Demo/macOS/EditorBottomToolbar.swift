//
//  EditorBottomToolbar.swift
//  Demo (macOS)
//
//  Created by Daniel Saidi on 2022-06-06.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import RichTextKit
import SwiftUI

struct EditorBottomToolbar: View, DemoToolbar {

    @EnvironmentObject
    var context: RichTextContext

    var body: some View {
        HStack {
            actionButtons
            Spacer()
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 7)
        .background(Color.white.opacity(0.1))
    }
}

struct EditorBottomToolbar_Previews: PreviewProvider {
    static var previews: some View {
        EditorBottomToolbar()
            .environmentObject(RichTextContext())
    }
}
