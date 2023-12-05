//
//  RichTextContext+CustomProperties.swift
//
//
//  Created by Dominik Bucher on 04.12.2023.
//

import SwiftUI

public extension RichTextContext {
    
    /// Get a binding for a certain color.
    func binding(for link: URL?) -> Binding<URL?> {
        Binding(
            get: { self.link },
            set: { self.setLink($0) }
        )
    }
    
    /// Set the link to context
    func setLink(_ url: URL?) {
        self.link = url
    }
}

