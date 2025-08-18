//
//  File.swift
//  Emoji Art
//
//  Created by JoseAlvarez on 8/18/25.
//

import SwiftUI

/// CGRect extension providing a center point property and initializer for positioning by center.
extension CGRect {
    var center: CGPoint {
        CGPoint(x: midX, y: midY)
    }

    init(center: CGPoint, size: CGSize) {
        self.init(
            origin: CGPoint(
                x: center.x - size.width / 2,
                y: center.y - size.height / 2
            ),
            size: size
        )
    }
}
