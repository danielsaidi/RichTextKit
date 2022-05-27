//
//  ColorRepresentable.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-28.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

#if os(macOS)
import AppKit

/**
 This typealias bridges platform-specific colors to simplify
 multi-platform support.
 */
public typealias ColorRepresentable = NSColor
#endif


#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit

/**
 This typealias bridges platform-specific colors to simplify
 multi-platform support.
 */
public typealias ColorRepresentable = UIColor
#endif
