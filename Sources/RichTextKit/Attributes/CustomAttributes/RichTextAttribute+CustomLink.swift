//
//  RichTextAttribute+CustomLink.swift
//
//
//  Created by Dominik Bucher on 01.12.2023.
//

import Foundation
import UIKit

extension RichTextAttribute {
    /**
     This attribute ensures that we set the link and its color is always the one we choose.
     Together with this, please set `linkTextAttributes = [:]` on UITextView instance. Otherwise
     the tintColor will always override the foregroundColor.
     */
    static let customLink: NSAttributedString.Key = .init("customLink")
}

public struct CustomLinkAttributes {
    init(link: String?, color: UIColor) {
        self.link = link
        self.color = color
    }
    
    let link: String?
    let color: UIColor
}
