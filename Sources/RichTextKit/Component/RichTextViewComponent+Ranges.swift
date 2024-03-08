//
//  RichTextViewComponent+Ranges.swift
//  RichTextKit
//
//  Created by Dominik Bucher
//

import Foundation

extension RichTextViewComponent {

    var notFoundRange: NSRange {
        .init(location: NSNotFound, length: 0)
    }
}
