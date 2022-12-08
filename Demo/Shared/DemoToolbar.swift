//
//  DemoToolbar.swift
//  Demo
//
//  Created by Daniel Saidi on 2022-06-06.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import RichTextKit
import SwiftUI

protocol DemoToolbar: View {

    var context: RichTextContext { get }
}

extension DemoToolbar {

    var actionButtons: some View {
        HStack {
            button(icon: .richTextActionCopy, action: context.copyCurrentSelection)
                .disabled(!context.canCopy)
            button(icon: .richTextActionUndo, action: context.undoLatestChange)
                .disabled(!context.canUndoLatestChange)
            button(icon: .richTextActionRedo, action: context.redoLatestChange)
                .disabled(!context.canRedoLatestChange)
        }
    }

    var divider: some View {
        Divider().frame(height: 10)
    }
}

private extension DemoToolbar {

    func button(
        icon: Image,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            icon.frame(height: 17)
        }
    }
}
