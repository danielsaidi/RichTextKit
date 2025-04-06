//
//  RichTextViewRepresentable.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2024-03-04.
//  Copyright © 2024 Daniel Saidi. All rights reserved.
//

#if macOS
import AppKit

/// This typealias bridges UIKit & AppKit native text views.
public typealias RichTextViewRepresentable = NSTextView
#endif

#if iOS || os(tvOS) || os(visionOS)
import UIKit

/// This typealias bridges UIKit & AppKit native text views.
public typealias RichTextViewRepresentable = UITextView
#endif
