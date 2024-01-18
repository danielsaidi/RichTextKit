//
//  Insertion.swift
//  
//
//  Created by Dominik Bucher on 17.01.2024.
//

import Foundation

extension String: Insertable {}
extension ImageRepresentable: Insertable {}
extension [ImageRepresentable]: Insertable {}
extension NSAttributedString: Insertable {}

public protocol Insertable {}

public struct Insertion<T: Insertable> {
    typealias Index = Int
    let content: T
    let at: Index
    let moveCursor: Bool
}

extension Insertion: Equatable {
    public static func == (lhs: Insertion<T>, rhs: Insertion<T>) -> Bool {
        return true
    }
    
    
}
