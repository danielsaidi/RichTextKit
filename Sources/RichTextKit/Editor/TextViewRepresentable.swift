//
//  TextViewRepresentable.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2024-03-04.
//  Copyright © 2024 Daniel Saidi. All rights reserved.
//

#if macOS
import AppKit

/**
 This typealias bridges platform-specific text views to make
 it easier to support multi-platform.
 */
public typealias TextViewRepresentable = NSTextView
#endif

#if iOS || os(tvOS) || os(visionOS)
import UIKit

/**
 This typealias bridges platform-specific text views to make
 it easier to support multi-platform.
 */
public typealias TextViewRepresentable = UITextView
#endif
