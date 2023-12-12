//
//  RichTextLinkSetter.swift
//
//
//  Created by Dominik Bucher on 12.12.2023.
//

import Foundation
#if macOS
import AppKit
#else
import UIKit
#endif


public class RichTextLinkSetter {
#if macOS
    let textView: NSTextView
    
    /// - param textView: The text view which should be observed and highlighted.
    /// - param notificationCenter: The notification center to subscribe in.
    ///   A testing seam. Defaults to `NotificationCenter.default`.
    init(textView: NSTextView, notificationCenter: NotificationCenter = .default) {
        self.textView = textView
        self.subscription = notificationCenter.addObserver(
            forName: NSTextStorage.didProcessEditingNotification,
            object: textView.textStorage,
            queue: nil,
            using: { [unowned self] notification in
                self.textViewDidChange(notification)
            }
        )
    }
#else
    let textView: UITextView
    /// - param textView: The text view which should be observed and highlighted.
    /// - param notificationCenter: The notification center to subscribe in.
    ///   A testing seam. Defaults to `NotificationCenter.default`.
    init(textView: UITextView, notificationCenter: NotificationCenter = .default) {
        self.textView = textView
        self.subscription = notificationCenter.addObserver(
            forName: NSTextStorage.didProcessEditingNotification,
            object: textView.textStorage,
            queue: nil,
            using: { [unowned self] notification in
                self.textViewDidChange(notification)
            }
        )
    }
#endif
    
    
    private var subscription: NSObjectProtocol!
    
    
#if macOS
    func textViewDidChange(_ notification: Notification) {
        textView.textStorage?.beginEditing()
        (textView as? RichTextView)?.renderLinks(in: textView.selectedRange, at: .zero)
        textView.textStorage?.endEditing()
    }
#else
    func textViewDidChange(_ notification: Notification) {
        textView.textStorage.beginEditing()
        (textView as? RichTextView)?.renderLinks(in: textView.selectedRange, at: .zero)
        textView.textStorage.endEditing()
    }
#endif
    
}
