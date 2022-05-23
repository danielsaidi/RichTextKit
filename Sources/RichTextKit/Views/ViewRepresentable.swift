//
//  ViewRepresentable.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-21.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import SwiftUI

#if os(iOS) || os(tvOS)
import UIKit

/**
 This typealias is used to bridge the platform-specific view
 representable protocols in AppKit and UIKit.
 */
typealias ViewRepresentable = UIViewRepresentable
#endif

#if os(macOS)
import AppKit

/**
 This typealias is used to bridge the platform-specific view
 representable protocols in AppKit and UIKit.
 */
typealias ViewRepresentable = NSViewRepresentable
#endif
