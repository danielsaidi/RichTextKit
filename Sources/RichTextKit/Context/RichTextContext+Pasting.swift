//
//  RichTextContext+Pasting.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2024-03-05.
//  Copyright © 2024 Daniel Saidi. All rights reserved.
//

import SwiftUI

public extension RichTextContext {

    /// Paste a certain rich text insertion.
    func paste<T: RichTextInsertable>(_ content: RichTextInsertion<T>) {
        guard let action = content.action else { return }
        trigger(action)
    }
}
