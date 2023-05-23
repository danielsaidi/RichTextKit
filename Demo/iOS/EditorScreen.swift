//
//  EditorScreen.swift
//  Demo (iOS)
//
//  Created by Daniel Saidi on 2022-06-06.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import RichTextKit
import SwiftUI

struct EditorScreen: View {

    init() {
        // RichTextEditor.standardRichTextFontSize = 100
    }

    @State
    private var text = NSAttributedString.empty

    @StateObject
    var context = RichTextContext()
    
    @State
    private var showConfirmationAlert = false
    
    @FocusState
    private var isEditorFocused: Bool
    
    @State
    private var refreshCount = 0

    var body: some View {
        VStack {
            editor.padding()
            toolbar
        }
        .background(Color.primary.opacity(0.15))
        .navigationTitle("RichTextKit")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                MainMenu()
            }
        }
        .viewDebug()
        .id(refreshCount) // Use id to force view refresh
    }
}

private extension EditorScreen {

    var editor: some View {
        ZStack(alignment: .bottomTrailing) {
            RichTextEditor(text: $text, context: context) {
                $0.textContentInset = CGSize(width: 10, height: 20)
            }
            .background(Material.regular)
            .cornerRadius(5)
            .focused($isEditorFocused)
            .focusedValue(\.richTextContext, context)

            Button(action: {
                showConfirmationAlert = true
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
                    .padding(10)
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 16))
        }
        .alert(isPresented: $showConfirmationAlert) {
            Alert(
                title: Text("Clear"),
                message: Text("Are you sure you want to clear the text?"),
                primaryButton: .default(Text("Clear")) {
                    clearContent()
                },
                secondaryButton: .cancel()
            )
        }
    }

    var toolbar: some View {
        RichTextKeyboardToolbar(
            context: context,
            leadingButtons: {},
            trailingButtons: {}
        )
    }
    
    // Function to clear the content of the editor by setting text to empty string and refreshing the view
    private func clearContent() {
      isEditorFocused = false // Editor should not be focused to allow view refresh
      DispatchQueue.main.async {
        text = NSAttributedString(string: "")
        refreshCount += 1  // Increment refreshCount to trigger view refresh
      }
    }

}

struct EditorScreen_Previews: PreviewProvider {
    
    static var previews: some View {
        EditorScreen()
    }
}
