//
//  NSImage+JpegData.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-05.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

#if canImport(AppKit)
import AppKit

public extension NSImage {

    /// Try to get JPEG compressed data for the AppKit image.
    func jpegData(compressionQuality: CGFloat) -> Data? {
        guard let image = cgImage else { return nil }
        let bitmap = NSBitmapImageRep(cgImage: image)
        return bitmap.representation(using: .jpeg, properties: [.compressionFactor: compressionQuality])
    }
}
#endif
