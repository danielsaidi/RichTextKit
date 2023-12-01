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
     */
    static let customLink: NSAttributedString.Key = .init("customLink")
}

struct CustomLinkAttributes {
    let link: String?
    let color: UIColor
}
