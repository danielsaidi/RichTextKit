//
//  String+Paragraph.swift
//  RichTextKit
//
//  Created by Daniel Saidi on 2022-05-29.
//  Copyright © 2022-2023 Daniel Saidi. All rights reserved.
//

import Foundation

public extension String {
    
    /**
     Backs to find the index of the first new line paragraph
     before the provided location, if any.
     
     A new paragraph is considered to start at the character
     after the newline char, not the newline itself.
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
     Looks forward to find the next new line paragraph after
     the provided location, if any. If no next paragraph can
     be found, the current is returned.
     
     A new paragraph is considered to start at the character
     after the newline char, not the newline itself.
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
     Looks forward to find the next new line paragraph after
     the provided location, if any. If no next paragraph can
     be found, the last index of the paragraph is returned.
     
     A new paragraph is considered to start at the character
     after the newline char, not the newline itself.
     */
    
    func findIndexOfNextParagraphOrEndofCurrent(from location: UInt) -> UInt {
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
     Returns the length of the paragraph found at the location provided..
     
     A new paragraph is considered to start at the character
     after the newline char, not the newline itself.
     */
    func findLengthOfCurrentParagraph(from location: UInt) -> Int {
        if isEmpty { return 0 }
        let startIndex = findIndexOfCurrentParagraph(from: location)
        let endIndex = findIndexOfNextParagraphOrEndofCurrent(from: location)
        return Int(endIndex)-Int(startIndex)
    }
    
    /**
     Returns the index of the word at the location provided..
     
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
