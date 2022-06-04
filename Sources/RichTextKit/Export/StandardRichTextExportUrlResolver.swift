//
//  StandardRichTextExportUrlResolver.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-02.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This is a typealias for the `FileManager` class, since it's
 the standard way to resolve export file urls.
 */
public typealias StandardRichTextExportUrlResolver = FileManager

extension FileManager: RichTextExportUrlResolver {}

public extension FileManager {

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
        in directory: FileManager.SearchPathDirectory) throws -> URL {
        let url = self
            .urls(for: directory, in: .userDomainMask).first?
            .appendingPathComponent(fileName)
            .appendingPathExtension(`extension`)
        guard let fileUrl = url else { throw RichTextExportError.cantCreateFileUrl(in: directory) }
        return fileUrl
    }

    /**
     Try to generate a unique file url in a certain directory.

     If needed, the function appends a counter until the url
     is unique. This means that the resulting url for a file
     url that has the file name `myFile.txt` may result in a
     url that has the file name `myFile-1.txt`.

     - Parameters:
       - fileName: The preferred file name.
       - extensions: The file extension.
       - directory: The directory in which to generate an url.
     */
    func uniqueFileUrl(
        withName fileName: String,
        extension: String,
        in directory: FileManager.SearchPathDirectory) throws -> URL {
        let url = try fileUrl(withName: fileName, extension: `extension`, in: directory)
        let uniqueUrl = uniqueUrl(for: url)
        return uniqueUrl
    }

    /**
     Get a unique url for the provided `url`, to ensure that
     no existing folder or file exists there.

     If needed, the function appends a counter until the url
     is unique. This means that the resulting url for a file
     url that has the file name `myFile.txt` may result in a
     url that has the file name `myFile-1.txt`.

     - Parameters:
       - url: The url to generate a unique url for.
     */
    func uniqueUrl(for url: URL) -> URL {
        if !fileExists(atPath: url.path) { return url }
        let fileExtension = url.pathExtension
        let noExtension = url.deletingPathExtension()
        let fileName = noExtension.lastPathComponent
        var counter = 1
        repeat {
            let newUrl = noExtension
                .deletingLastPathComponent()
                .appendingPathComponent(fileName.appending("-\(counter)"))
                .appendingPathExtension(fileExtension)
            if !fileExists(atPath: newUrl.path) { return newUrl }
            counter += 1
        } while true
    }
}
