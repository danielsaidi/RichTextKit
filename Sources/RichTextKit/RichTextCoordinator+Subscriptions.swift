//
//  RichTextCoordinator+Subscriptions.swift
//  OribiRichTextKit
//
//  Created by Daniel Saidi on 2021-12-06.
//  Copyright © 2021 Oribi. All rights reserved.
//

#if os(iOS) || os(macOS) || os(tvOS)
import SwiftUI

extension RichTextCoordinator {

    /**
     Make the coordinator subscribe to context changes.
     */
    func subscribeToContextChanges() {
        subscribeToIsBold()
        subscribeToIsEditingText()
        subscribeToIsItalic()
        subscribeToIsUnderlined()
    }
}

private extension RichTextCoordinator {

    func subscribeToIsBold() {
        context.$isBold
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in self?.setStyle(.bold, to: $0) })
            .store(in: &cancellables)
    }

    func subscribeToIsEditingText() {
        context.$isEditingText
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in self?.setIsEditing(to: $0) })
            .store(in: &cancellables)
    }

    func subscribeToIsItalic() {
        context.$isItalic
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in self?.setStyle(.italic, to: $0) })
            .store(in: &cancellables)
    }

    func subscribeToIsUnderlined() {
        context.$isUnderlined
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in self?.setStyle(.underlined, to: $0) })
            .store(in: &cancellables)
    }
}

private extension RichTextCoordinator {

    func setIsEditing(to newValue: Bool) {
        if newValue == textView.isFirstResponder { return }
        if newValue {
            textView.becomeFirstResponder()
        } else {
            textView.resignFirstResponder()
        }
    }

    func setStyle(_ style: RichTextStyle, to newValue: Bool) {
        textView.setRichTextStyle(style, to: newValue)
    }
}
#endif
