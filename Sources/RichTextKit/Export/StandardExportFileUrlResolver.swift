//
//  StandardExportFileUrlResolver.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-06-02.
//  Copyright © 2022 Daniel Saidi. All rights reserved.
//

import Foundation

/**
 This is a typealias for the `FileManager` class.

 The reason why this is a typealias and not a class, is that
 `FileManager` is the only resolver in the library.
 */
public typealias StandardExportFileUrlResolver = FileManager
