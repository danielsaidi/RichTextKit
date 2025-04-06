//
//  RichTextAlignment.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-28.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import SwiftUI

extension NSTextAlignment: RichTextLabelValue {}

public extension NSTextAlignment {

    @available(*, deprecated, renamed: "defaultIcon")
    var icon: Image {
        switch self {
        case .left: .richTextAlignmentLeft
        case .right: .richTextAlignmentRight
        case .center: .richTextAlignmentCenter
        case .justified: .richTextAlignmentJustified
        default: .richTextAlignmentLeft
        }
    }

    @available(*, deprecated, renamed: "defaultTitle")
    var title: String { defaultTitle }

    @available(*, deprecated, renamed: "defaultTitleKey")
    var titleKey: RTKL10n { defaultTitleKey }
}
