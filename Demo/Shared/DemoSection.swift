//
//  DemoSection.swift
//  Demo
//
//  Created by Daniel Saidi on 2022-06-05.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation
import SwiftUI

enum DemoSection: String, Equatable, Identifiable {

    case aboutApp
    case textEditor
}

extension DemoSection {

    var id: String { rawValue }

    var icon: Image {
        switch self {
        case .aboutApp: return .about
        case .textEditor: return .textEditor
        }
    }

    var title: String {
        switch self {
        case .aboutApp: return "About app"
        case .textEditor: return "Editor"
        }
    }

    var url: URL {
        guard let url = URL(string: rawValue) else {
            fatalError("Invalid URL")
        }
        return url
    }
}
