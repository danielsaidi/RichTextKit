//
//  RichTextAttributeReader.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-27.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This protocol can be implemented any types that can provide
 extended rich text attribute functionality.

 The protocol is implemented by `NSAttributedString` as well
 as other library types.
 */
public protocol RichTextAttributeReader: RichTextReader {}

extension NSAttributedString: RichTextAttributeReader {}
