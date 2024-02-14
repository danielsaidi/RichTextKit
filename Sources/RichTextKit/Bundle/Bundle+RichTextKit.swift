//
//  Bundle+RichTextKit.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-08-21.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import Foundation

extension Bundle {

    func bundle(for locale: Locale) -> Bundle? {
        guard let bundlePath = bundlePath(for: locale) else { return nil }
        return Bundle(path: bundlePath)
    }

    func bundlePath(for locale: Locale) -> String? {
        if #available(iOS 16, macOS 13, tvOS 16, watchOS 9, *) {
            bundlePath(named: locale.identifier) ?? bundlePath(named: locale.language.languageCode?.identifier)
        } else {
            bundlePath(named: locale.identifier) ?? bundlePath(named: locale.languageCode)
        }
    }

    func bundlePath(named name: String?) -> String? {
        path(forResource: name ?? "", ofType: "lproj")
    }
}

private extension Bundle {

    class BundleFinder {}
}
