//
//  FontRepresentable.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-24.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

#if canImport(UIKit)
import UIKit

/**
 This typealias is used to bridge the platform-specific font
 types in AppKit and UIKit.
 */
public typealias FontRepresentable = UIFont
#endif

#if canImport(AppKit)
import AppKit

/**
 This typealias is used to bridge the platform-specific font
 types in AppKit and UIKit.
 */
public typealias FontRepresentable = NSFont
#endif

