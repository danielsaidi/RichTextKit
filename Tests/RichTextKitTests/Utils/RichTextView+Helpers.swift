//
//  RichTextView+Helpers.swift
//
//
//  Created by Dominik Bucher on 15.01.2024.
//

import Foundation
import RichTextKit

#if iOS || tvOS
import UIKit

extension UITextView {
    func simulateTyping(of text: String) {
        replace(
            textRange(
                from: endOfDocument,
                to: endOfDocument
            )!,
            withText: text
        )
    }
}
#elseif macOS
import AppKit
extension NSTextView {
    func simulateTyping(of text: String) {
        // TODO: Implement
    }
}
#endif
