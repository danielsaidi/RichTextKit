//
//  NSAttributedString+Format.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-02.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation

public extension NSAttributedString {
    
    /**
     Try to generate data for a certain data format.
     */
    func data(for format: RichTextFormat) throws -> Data {
        switch format {
        case .richTextKit: return try keyedArchiveData()
        case .plainText: return try plainTextData()
        case .rtf: return try rtfData()
        }
    }
}
