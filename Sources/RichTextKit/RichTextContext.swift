//
//  RichTextContext.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-22.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import SwiftUI

/**
 This context can be used to observe state for any rich text
 editor, as well as other properties.

 SwiftUI can observe the published properties to keep the UI
 of an app in sync, while a coordinator can subscribe to any
 property to keep a wrapped text view in sync.
 */
public class RichTextContext: ObservableObject {

    public init() {}
}
