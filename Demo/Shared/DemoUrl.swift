//
//  DemoUrl.swift
//  Demo
//
//  Created by Daniel Saidi on 2022-06-05.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation
import SwiftUI

enum DemoUrl: String, Equatable, Identifiable {

    case github = "https://github.com/danielsaidi/RichTextKit"
    case documentation = "https://danielsaidi.github.io/RichTextKit/documentation/richtextkit/"
}

extension DemoUrl {

    var id: String { rawValue }

    var icon: Image {
        switch self {
        case .github: return .safari
        case .documentation: return .documentation
        }
    }

    var title: String {
        switch self {
        case .github: return "GitHub"
        case .documentation: return "Documentation"
        }
    }

    var url: URL {
        guard let url = URL(string: rawValue) else {
            fatalError("Invalid URL")
        }
        return url
    }
}
