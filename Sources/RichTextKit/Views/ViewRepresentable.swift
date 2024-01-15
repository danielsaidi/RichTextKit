//
//  ViewRepresentable.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-21.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import SwiftUI

#if iOS || tvOS
import UIKit

/**
 This typealias bridges platform-specific view representable
 types to simplify multi-platform support.
 */
typealias ViewRepresentable = UIViewRepresentable
#endif

#if macOS
import AppKit

/**
 This typealias bridges platform-specific view representable
 types to simplify multi-platform support.
 */
typealias ViewRepresentable = NSViewRepresentable
#endif
