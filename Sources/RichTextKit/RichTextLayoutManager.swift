//
//  File.swift
//  
//
//  Created by James Bradley on 3/19/23.
//
#if os(iOS) || os(macOS) || os(tvOS)
import UIKit

/**
 This coordinator is used to keep a ``RichTextView`` in sync
 with a ``RichTextContext``.

 The coordinator sets itself as the text view's delegate and
 updates the context when things change in the text view. It
 also subscribes to context observable changes and keeps the
 text view in sync with these changes.

 You can inherit this class to customize the coordinator for
 your own use cases.
 */

open class RichTextLayoutManager: NSLayoutManager {
    
    func drawTag(of rect: CGRect) {
        let path = UIBezierPath()
        let width = (rect.maxY - rect.minY) * 1.10
        let inset = width/4
        path.lineWidth = width
        path.lineCapStyle = .round
        path.move(to: CGPoint(x: rect.minX + inset, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX - inset, y: rect.maxY))
        UIColor.lightGray.setStroke()
        path.stroke()
    }
    
    open override func drawUnderline(forGlyphRange glyphRange: NSRange, underlineType underlineVal: NSUnderlineStyle, baselineOffset: CGFloat, lineFragmentRect lineRect: CGRect, lineFragmentGlyphRange lineGlyphRange: NSRange, containerOrigin: CGPoint) {
            
        if (underlineVal.rawValue != 0 && underlineVal == .tagBasic) {
                
                let charRange = characterRange(forGlyphRange: glyphRange, actualGlyphRange: nil)
            if let underlineColor = textStorage?.attribute(NSAttributedString.Key.underlineColor, at: charRange.location, effectiveRange: nil) as? UIColor {
                    underlineColor.setStroke()
                }
                
                if let container = textContainer(forGlyphAt: glyphRange.location, effectiveRange: nil) {
                    let boundingRect = self.boundingRect(forGlyphRange: glyphRange, in: container)
                    let offsetRect = boundingRect.offsetBy(dx: containerOrigin.x, dy: containerOrigin.y - (boundingRect.maxY - boundingRect.minY)/2)
                    
                    drawTag(of: offsetRect)
                }
            }
            else {
                super.drawUnderline(forGlyphRange: glyphRange, underlineType: underlineVal, baselineOffset: baselineOffset, lineFragmentRect: lineRect, lineFragmentGlyphRange: lineGlyphRange, containerOrigin: containerOrigin)
            }
        }
    
}

#endif
