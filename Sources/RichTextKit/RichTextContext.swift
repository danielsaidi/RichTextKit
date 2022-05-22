//
//  RichTextContext.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-22.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This context can be used to observe rich text while working
 with a rich text editor, as well as other properties.

 SwiftUI can observe the published properties to keep an app
 in sync, while a coordinator can subscribe to properties to
 keep a wrapped text view in sync.
 */
public class RichTextContext: ObservableObject {

    /**
     Create a rich text context with an attributed string.

     - Parameters:
       - text: The rich text content.
     */
    public init(
        text: NSAttributedString) {
        self.text = text
    }

    /**
     Create a rich text context with an plain string.

     - Parameters:
       - text: The plain text content.
     */
    public init(
        text: String) {
        self.text = NSAttributedString(string: text)
    }


    /**
     The rich text content.
     */
    @Published
    public var text: NSAttributedString
}
