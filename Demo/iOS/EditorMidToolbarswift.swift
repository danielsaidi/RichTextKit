//
//  EditorMidToolbar.swift
//  Demo (iOS)
//
//  Created by Daniel Saidi on 2022-06-06.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import RichTextKit
import SwiftUI

struct EditorMidToolbar: View, DemoToolbar {

    @EnvironmentObject
    var context: RichTextContext

    var body: some View {
        HStack {
            RichTextStyleToggleGroup(context: context)
            Spacer()
            RichTextAlignmentPicker(selection: $context.textAlignment)
            Spacer()
            colorPickers
        }
    }
}

struct EditorMidToolbar_Previews: PreviewProvider {
    static var previews: some View {
        EditorMidToolbar()
    }
}
