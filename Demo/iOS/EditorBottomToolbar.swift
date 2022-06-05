//
//  EditorBottomToolbar.swift
//  Demo (iOS)
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
        actionButtons
    }
}

struct EditorBottomToolbar_Previews: PreviewProvider {
    static var previews: some View {
        EditorBottomToolbar()
    }
}
