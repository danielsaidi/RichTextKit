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

        subscribeToHeaderLevel()
        subscribeToAlignment()
        subscribeToFontName()
        subscribeToFontSize()
        subscribeToIsEditable()
        subscribeToIsEditingText()
        subscribeToLineSpacing()
    }
}

private extension RichTextCoordinator {

    func subscribe<T>(
        to publisher: Published<T>.Publisher,
        action: @escaping (T) -> Void
    ) {
        publisher
            .sink(receiveValue: action)
            .store(in: &cancellables)
    }

    func subscribeToHeaderLevel() {
        subscribe(to: context.$headerLevel) { [weak self] in
            self?.textView.setHeaderLevel($0)
        }
    }

    func subscribeToAlignment() {
        subscribe(to: context.$textAlignment) { [weak self] in
            self?.handle(.setAlignment($0))
        }
    }

    func subscribeToFontName() {
        subscribe(to: context.$fontName) { [weak self] in
            self?.textView.setRichTextFontName($0)
        }
    }

    func subscribeToFontSize() {
        subscribe(to: context.$fontSize) { [weak self] in
            self?.textView.setRichTextFontSize($0)
        }
    }

    func subscribeToIsEditable() {
        subscribe(to: context.$isEditable) { [weak self] in
            self?.setIsEditable(to: $0)
        }
    }

    func subscribeToIsEditingText() {
        subscribe(to: context.$isEditingText) { [weak self] in
            self?.setIsEditing(to: $0)
        }
    }

    // TODO: Not done yet
    func subscribeToLineSpacing() {
        // subscribe(to: context.$lineSpacing) { [weak self] in
        //     self?.textView.setRichTextLineSpacing($0)
        // }
    }
}
#endif
