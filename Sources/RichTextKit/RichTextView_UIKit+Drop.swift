//
//  RichTextView_UIKit+Drop.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-05.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

#if os(iOS)
import UIKit
import UniformTypeIdentifiers

extension RichTextView: UIDropInteractionDelegate {}

public extension RichTextView {
    
    /**
     The interaction types that are supported by drag & drop.
     */
    var supportedDropInteractionTypes: [UTType] {
        [.image, .text, .plainText, .utf8PlainText, .utf16PlainText]
    }
    
    /**
     Whether or not the view can handle a drop session.
     */
    func dropInteraction(
        _ interaction: UIDropInteraction,
        canHandle session: UIDropSession) -> Bool {
        if session.hasImage && imageDropConfiguration == .disabled { return false }
        let identifiers = supportedDropInteractionTypes.map { $0.identifier }
        return session.hasItemsConforming(toTypeIdentifiers: identifiers)
    }
    
    /**
     Handle an updated drop session.

     - Parameters:
       - interaction: The drop interaction to handle.
       - session: The drop session to handle.
     */
    func dropInteraction(
        _ interaction: UIDropInteraction,
        sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        let operation = dropInteractionOperation(for: session)
        return UIDropProposal(operation: operation)
    }
    
    /**
     The drop interaction operation for the provided session.

     - Parameters:
       - session: The drop session to handle.
     */
    func dropInteractionOperation(
        for session: UIDropSession) -> UIDropOperation {
        guard session.hasDroppableContent else { return .forbidden }
        let location = session.location(in: self)
        return frame.contains(location) ? .copy : .cancel
    }
    
    /**
     Handle a performed drop session.
     
     In this function, we reverse the item collection, since
     each item will be pasted at the drop point, which would
     result in a revese result.
     */
    func dropInteraction(
        _ interaction: UIDropInteraction,
        performDrop session: UIDropSession) {
        guard session.hasDroppableContent else { return }
        let location = session.location(in: self)
        guard let range = self.range(at: location) else { return }
        performImageDrop(with: session, at: range)
        performTextDrop(with: session, at: range)
    }
}

extension RichTextView {
    
    /**
     Refresh the drop interaction based on the drop config.
     */
    func refreshDropInteraction() {
        switch imageDropConfiguration {
        case .disabled:
            removeInteraction(imageDropInteraction)
        case .disabledWithWarning, .enabled:
            addInteraction(imageDropInteraction)
        }
    }
}

private extension RichTextView {
    
    /**
     Performe an image drop session.
     
     We reverse the item collection, since each item will be
     pasted at the original drop point.
     */
    func performImageDrop(with session: UIDropSession, at range: NSRange) {
        guard validateImageInsertion(for: imageDropConfiguration) else { return }
        session.loadObjects(ofClass: UIImage.self) { items in
            let images = items.compactMap { $0 as? UIImage }.reversed()
            images.forEach { self.pasteImage($0, at: range.location) }
        }
    }
    
    /**
     Perform a text drop session.
     
     We reverse the item collection, since each item will be
     pasted at the original drop point.
     */
    func performTextDrop(with session: UIDropSession, at range: NSRange) {
        if session.hasImage { return }
        _ = session.loadObjects(ofClass: String.self) { items in
            let strings = items.reversed()
            strings.forEach { self.pasteText($0, at: range.location) }
        }
    }
}

private extension UIDropSession {
    
    var hasDroppableContent: Bool {
        hasImage || hasText
    }
    
    var hasImage: Bool {
        canLoadObjects(ofClass: UIImage.self)
    }
    
    var hasText: Bool {
        canLoadObjects(ofClass: String.self)
    }
}
#endif
