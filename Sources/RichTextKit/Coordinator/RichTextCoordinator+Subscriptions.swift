//
//  RichTextCoordinator+Subscriptions.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-22.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

#if iOS || macOS || os(tvOS) || os(visionOS)
import SwiftUI

extension RichTextCoordinator {

    /// Subscribe to observable context state changes.
    ///
    /// The coordinator subscribes to both actions triggered
    /// by various buttons via the context, but also to some
    /// context value that are changed through view bindings.
    func subscribeToUserActions() {
        context.actionPublisher.sink { [weak self] action in
            self?.handle(action)
        }
        .store(in: &cancellables)

        subscribeToAlignment()
        subscribeToFontName()
        subscribeToFontSize()
        subscribeToIsEditingText()
        subscribeToLineSpacing()
    }
}

private extension RichTextCoordinator {

    func subscribeToAlignment() {
        context.$textAlignment
            .sink { [weak self] in
                self?.handle(.setAlignment($0))
            }
            .store(in: &cancellables)
    }

    func subscribeToFontName() {
        context.$fontName
            .sink { [weak self] in
                self?.textView.setRichTextFontName($0)
            }
            .store(in: &cancellables)
    }

    func subscribeToFontSize() {
        context.$fontSize
            .sink { [weak self] in
                self?.textView.setRichTextFontSize($0)
            }
            .store(in: &cancellables)
    }

    func subscribeToIsEditingText() {
        context.$isEditingText
            .sink { [weak self] in
                self?.setIsEditing(to: $0)
            }
            .store(in: &cancellables)
    }

    func subscribeToLineSpacing() {
        context.$lineSpacing
            .sink { [weak self] in
                self?.textView.setRichTextLineSpacing($0)
            }
            .store(in: &cancellables)
    }
}
#endif
