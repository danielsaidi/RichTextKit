//
//  RichTextCoordinator+ColorsSubscriptions.swift
//
//
//  Created by Dominik Bucher on 15.12.2023.
//

#if iOS || macOS || tvOS
import Foundation

extension RichTextCoordinator {

    func setColor(_ color: ColorRepresentable, for coloredAttribute: RichTextColor) {
        var applyRange: NSRange? = nil
        if textView.hasSelectedRange {
            applyRange = textView.selectedRange
        }
        switch coloredAttribute {
        case .foreground:
            setForegroundColor(color, at: applyRange)
        case .background:
            setBackgroundColor(color, at: applyRange)
        case .strikethrough:
            setStrikethroughColor(color, at: applyRange)
        case .stroke:
            setStrokeColor(color, at: applyRange)
        case .underline:
            setUnderlineColor(color, at: applyRange)
        case .undefined:
            break
        }
    }

    private func setStrikethroughColor(_ color: ColorRepresentable, at range: NSRange?) {
        if let range {
            self.textView.setRichTextColor(.strikethrough, to: color, at: range)
        } else {
            self.textView.setTypingAttribute(.strikethroughColor, to: color)
        }
    }

    private func setStrokeColor(_ color: ColorRepresentable, at range: NSRange?) {
        if let range {
            self.textView.setRichTextColor(.stroke, to: color, at: range)
        } else {
            self.textView.setTypingAttribute(.strokeColor, to: color)
        }
    }

    private func setForegroundColor(_ color: ColorRepresentable, at range: NSRange?) {
        if let range {
            self.textView.setRichTextColor(.foreground, to: color, at: range)
        } else {
            self.textView.setTypingAttribute(.foregroundColor, to: color)
        }
    }

    private func setBackgroundColor(_ color: ColorRepresentable, at range: NSRange?) {
        if let range {
            self.textView.setRichTextColor(.background, to: color, at: range)
        } else {
            self.textView.setTypingAttribute(.backgroundColor, to: color)
        }
    }

    private func setUnderlineColor(_ color: ColorRepresentable, at range: NSRange?) {
        if let range {
            self.textView.setRichTextColor(.underline, to: color, at: range)
        } else {
            self.textView.setTypingAttribute(.underlineColor, to: color)
        }
    }
}
#endif
