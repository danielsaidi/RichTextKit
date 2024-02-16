//
//  ImageRepresentable.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-28.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

/// This typealias bridges platform-specific image types.
public typealias ImageRepresentable = NSImage

public extension ImageRepresentable {

    /// Try to get a CoreGraphic image from the AppKit image.
    var cgImage: CGImage? {
        cgImage(forProposedRect: nil, context: nil, hints: nil)
    }
    
    /// Try to get JPEG compressed data for the AppKit image.
    func jpegData(compressionQuality: CGFloat) -> Data? {
        guard let image = cgImage else { return nil }
        let bitmap = NSBitmapImageRep(cgImage: image)
        return bitmap.representation(using: .jpeg, properties: [.compressionFactor: compressionQuality])
    }
}
#endif

#if canImport(UIKit)
import UIKit

/// This typealias bridges platform-specific image types.
public typealias ImageRepresentable = UIImage
#endif
