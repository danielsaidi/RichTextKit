//
//  RichTextScriptButtons.swift
//  QBank
//
//  Created by Mahmudul Hasan on 2023-09-19.
//

import SwiftUI

#if os(macOS)
struct RichTextScriptButtons: View {

    /**
     Creates controls to add subscript and superscript

     - Parameters:
     - context: The context to apply changes to.
     */
    init(context: RichTextContext){
        self.context = context
        selectedRange = context.selectedRange
        textAtRange = context.attributedString.richText(at: selectedRange)
        textColor = context.attributedString.foregroundColor(at: selectedRange) ?? .labelColor
    }

    @ObservedObject
    private var context: RichTextContext
    /// Range that user selected
    private var selectedRange: NSRange
    /// Text at that range
    private var textAtRange: NSAttributedString
    /// Color of that text
    private var textColor: NSColor

    var body: some View {

        HStack {
            Button("SuperScript", systemImage: "textformat.superscript") {

                if selectedRange.length > 0 {
                    let attributes: [NSAttributedString.Key : Any] = [
                        NSAttributedString.Key.superscript: 1,
                        NSAttributedString.Key.foregroundColor: textColor
                    ]

                    let superScriptedString = NSAttributedString(string: textAtRange.string, attributes: attributes)

                    let currentMutableText = context.attributedString as! NSMutableAttributedString
                    currentMutableText.replaceCharacters(in: selectedRange, with: superScriptedString)

                    context.setAttributedString(to: currentMutableText)
                }


            }

            Button("SubScript", systemImage: "textformat.subscript") {

                if selectedRange.length > 0 {
                    let attributes: [NSAttributedString.Key : Any] = [
                        NSAttributedString.Key.superscript: -1,
                        NSAttributedString.Key.foregroundColor: textColor
                    ]

                    let superScriptedString = NSAttributedString(string: textAtRange.string, attributes: attributes)

                    let currentMutableText = context.attributedString as! NSMutableAttributedString
                    currentMutableText.replaceCharacters(in: selectedRange, with: superScriptedString)

                    context.setAttributedString(to: currentMutableText)
                }
            }
        }
    }
}
#endif
