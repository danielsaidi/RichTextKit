//
//  ViewRepresentable.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-21.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import SwiftUI

#if canImport(UIKit)
import UIKit

/**
 This typealias represents a `NSViewRepresentable` in AppKit
 and `UIViewRepresentable` in UIKit.
 */
typealias ViewRepresentable = UIViewRepresentable
#endif

#if os(macOS)
import AppKit

/**
 This typealias represents a `NSViewRepresentable` in AppKit
 and `UIViewRepresentable` in UIKit.
 */
typealias ViewRepresentable = NSViewRepresentable
#endif
