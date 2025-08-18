//
//  Extensions.swift
//  Emoji Art
//
//  Created by JoseAlvarez on 8/11/25.
//

import SwiftUI

typealias CGOffset = CGSize

/// CGOffset extension adding support for addition operations between offsets.
extension CGOffset {
    static func + (lhs: CGOffset, rhs: CGOffset) -> CGOffset {
        CGOffset(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }

    static func += (lhs: inout CGOffset, rhs: CGOffset) {
        lhs = lhs + rhs
    }
}
