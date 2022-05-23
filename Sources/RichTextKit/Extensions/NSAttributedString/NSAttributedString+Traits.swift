//
//  NSAttributedString+Traits.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-24.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation

public extension NSAttributedString {

    /**
     Get the symbolic font traits at a certain `range`.

     - Parameters:
       - range: The range to get the traits from.
     */
    func symbolicTraits(at range: NSRange) -> FontDescriptor.SymbolicTraits? {
        font(at: range)?.fontDescriptor.symbolicTraits
    }
}
