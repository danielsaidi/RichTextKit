//
//  FileManager+Url.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-02.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation

public extension FileManager {
    
    /**
     This enum defines errors that can be thrown when a file
     manager fails to perform export operations.
     */
    enum ExportError: Error {
        case cantCreateFile(at: URL)
        case cantGenerateFileUrl(in: FileManager.SearchPathDirectory)
    }
    
    /**
     Try to generate a file url in a certain directory.
     */
    func fileUrl(
        withName fileName: String,
        extension: String,
        in directory: FileManager.SearchPathDirectory = .documentDirectory) throws -> URL {
        let url = self
            .urls(for: directory, in: .userDomainMask).first?
            .appendingPathComponent(fileName)
            .appendingPathExtension(`extension`)
        guard let fileUrl = url else { throw ExportError.cantGenerateFileUrl(in: directory) }
        return fileUrl
    }
    
    /**
     Try to generate a unique file url in a certain directory.
     */
    func uniqueFileUrl(
        withName fileName: String,
        extension: String,
        in directory: FileManager.SearchPathDirectory = .documentDirectory) throws -> URL {
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
     */
    func uniqueUrl(
        for url: URL,
        separator: String = "-") -> URL {
        if !fileExists(atPath: url.path) { return url }
        let fileExtension = url.pathExtension
        let noExtension = url.deletingPathExtension()
        let fileName = noExtension.lastPathComponent
        var counter = 1
        repeat {
            let newUrl = noExtension
                .deletingLastPathComponent()
                .appendingPathComponent(fileName.appending("\(separator)\(counter)"))
                .appendingPathExtension(fileExtension)
            if !fileExists(atPath: newUrl.path) { return newUrl }
            counter += 1
        } while true
    }
}
