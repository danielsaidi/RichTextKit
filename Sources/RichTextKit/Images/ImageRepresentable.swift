//
//  ImageRepresentable.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-28.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

#if canImport(AppKit)
import AppKit

/**
 This typealias bridges platform-specific fonts, to simplify
 multi-platform support.
 */
public typealias ImageRepresentable = NSImage
#endif

#if canImport(UIKit)
import UIKit

/**
 This typealias bridges platform-specific fonts, to simplify
 multi-platform support.
 */
public typealias ImageRepresentable = UIImage
#endif
