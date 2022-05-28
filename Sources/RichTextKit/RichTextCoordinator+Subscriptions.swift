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

    func subscribeToContextChanges() {
        subscribeToIsBold()
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

    // TODO: Add this to textView instead (or protocol)
    func setStyle(_ style: RichTextStyle, to newValue: Bool) {
        let range = textView.selectedRange
        let styles = textView.richTextStyles(at: range)
        let isSet = styles.hasStyle(style)
        if newValue == isSet { return }
        textView.setRichTextStyle(style, to: newValue, at: range)
    }
}
#endif
