//
//  String+Paragraph.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-29.
//  Copyright © 2022-2024 Daniel Saidi. All rights reserved.
//

import Foundation

public extension String {

    /**
     Look backward to find the index of the paragraph before
     the provided location, if any.
     */
    func findIndexOfCurrentParagraph(from location: UInt) -> UInt {
        if isEmpty { return 0 }
        let count = UInt(count)
        var index = min(location, count-1)
        repeat {
            guard index > 0, index < count else { break }
            guard let char = character(at: index - 1) else { break }
            if char == .newLine || char == .carriageReturn { break }
            index -= 1
        } while true
        return max(index, 0)
    }

    /**
     Look forward to find the index of a paragraph after the
     provided location, if any.
     */
    func findIndexOfNextParagraph(from location: UInt) -> UInt {
        var index = location
        repeat {
            guard let char = character(at: index) else { break }
            index += 1
            guard index < count else { break }
            if char == .newLine || char == .carriageReturn { break }
        } while true
        let found = index < count
        return found ? index : findIndexOfCurrentParagraph(from: location)
    }

    /**
     Look forward to find the index of a paragraph after the
     provided location, if any.
     */
    func findIndexOfNextParagraphOrEndOfCurrent(from location: UInt) -> UInt {
        var index = location
        repeat {
            guard let char = character(at: index) else { break }
            index += 1
            guard index < count else { break }
            if char == .newLine || char == .carriageReturn { break }
        } while true
        let found = index < count
        return UInt(found ? index : UInt(count))
    }

    /**
     Get the length of the paragraph at a provided location.
     */
    func findLengthOfCurrentParagraph(from location: UInt) -> Int {
        if isEmpty { return 0 }
        let startIndex = findIndexOfCurrentParagraph(from: location)
        let endIndex = findIndexOfNextParagraphOrEndOfCurrent(from: location)
        return Int(endIndex)-Int(startIndex)
    }

    /**
     Get the index of the word at the provided text location.

     A word is considered to be a length of text between two
     breaking characters or space characters.
     */
    func findIndexOfCurrentWord(from location: UInt) -> UInt {
        if isEmpty { return 0 }
        let count = UInt(count)
        var index = min(location, count-1)
        repeat {
            guard index > 0, index < count else { break }
            guard let char = character(at: index - 1) else { break }
            if char == .space || char == .newLine || char == .carriageReturn { break }
            index -= 1
        } while true
        return max(index, 0)
    }
}
