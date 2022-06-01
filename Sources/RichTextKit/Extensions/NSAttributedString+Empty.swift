//
//  NSAttributedString+Empty.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-01.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation

extension NSAttributedString {
 
    /**
     Create an empty attributed string.
     */
    static var empty: NSAttributedString {
        NSAttributedString(string: "")
    }
}
