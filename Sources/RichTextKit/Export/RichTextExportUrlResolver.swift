//
//  RichTextExportUrlResolver.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-02.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This protocol can be implemented by types that can generate
 file urls, for instance when exporting rich text files.

 The protocol is implemented by `FileManager`, which is used
 by default by the library.
 */
public protocol RichTextExportUrlResolver {

    /**
     Try to generate a file url in a certain directory.

     - Parameters:
       - fileName: The preferred file name.
       - extensions: The file extension.
       - directory: The directory in which to generate an url.
     */
    func fileUrl(
        withName fileName: String,
        extension: String,
        in directory: FileManager.SearchPathDirectory
    ) throws -> URL

    /**
     Try to generate a unique file url in a certain directory.

     - Parameters:
       - fileName: The preferred file name.
       - extensions: The file extension.
       - directory: The directory in which to generate an url.
     */
    func uniqueFileUrl(
        withName fileName: String,
        extension: String,
        in directory: FileManager.SearchPathDirectory
    ) throws -> URL

    /**
     Get a unique url for the provided url, to ensure that a
     file with the same name doesn't exist.

     - Parameters:
       - url: The url to generate a unique url for.
       - separator: The separator to use for separating the counter.
     */
    func uniqueUrl(for url: URL) -> URL
}
