//
//  ColorRepresentable.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-28.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

#if macOS
import AppKit

/// This typealias bridges platform-specific colors.
public typealias ColorRepresentable = NSColor
#endif

#if iOS || os(tvOS) || os(watchOS) || os(visionOS)
import UIKit

/// This typealias bridges platform-specific colors.
public typealias ColorRepresentable = UIColor
#endif
