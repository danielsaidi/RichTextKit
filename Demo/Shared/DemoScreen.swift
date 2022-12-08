//
//  DemoScreen.swift
//  Demo
//
//  Created by Daniel Saidi on 2022-06-05.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import SwiftUI

enum DemoScreen: String, Equatable, Identifiable {

    case about
    case editor
}

extension DemoScreen {

    var id: String { rawValue }

    var icon: Image {
        switch self {
        case .about: return .about
        case .editor: return .textEditor
        }
    }

    var label: some View {
        Label {
            Text(title)
        } icon: {
            icon
        }
    }

    var title: String {
        switch self {
        case .about: return "About"
        case .editor: return "Editor"
        }
    }

    var url: URL {
        guard let url = URL(string: rawValue) else {
            fatalError("Invalid URL")
        }
        return url
    }
}
