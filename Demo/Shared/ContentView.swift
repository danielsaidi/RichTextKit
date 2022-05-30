//
//  ContentView.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-22.
//



import RichTextKit
import SwiftUI

struct ContentView: View {

    @State
    private var text = NSAttributedString(string: "test")

    @StateObject
    private var context = RichTextContext()

    var body: some View {
        NavigationView {
            VStack {
                RichTextEditor(text: $text, context: context)
                    .cornerRadius(5)
                    .frame(height: 100)
                HStack {
                    button(for: .bold)
                    button(for: .italic)
                    button(for: .underlined)
                }
                RichTextAlignmentPicker(
                    title: "Alignment",
                    selection: $context.alignment).pickerStyle(.segmented)
                HStack {
                    ColorPicker("background", selection: context.backgroundColorBinding)
                    ColorPicker("foreground", selection: context.foregroundColorBinding)
                }
                Button(action: context.toggleIsEditing) {
                    Image.edit
                }.highlighted(if: context.isEditingText)
                Spacer()
            }
        }
        .padding()
        .background(Color.gray.opacity(0.3))
    }
}

private extension ContentView {

    func button(for style: RichTextStyle) -> some View {
        Button(action: { context.toggle(style) }) {
            style.icon
        }
        .highlighted(if: context.hasStyle(style))
        .buttonStyle(.bordered)
    }

    func button(for alignment: RichTextAlignment) -> some View {
        Button(action: { context.alignment = alignment }) {
            alignment.icon
        }
        .highlighted(if: context.alignment == alignment)
        .buttonStyle(.bordered)
    }
}

private extension Button {

    func highlighted(if condition: Bool) -> some View {
        foregroundColor(condition ? .accentColor : .primary)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
