//
//  Extensions.swift
//  Emoji Art
//
//  Created by JoseAlvarez on 8/11/25.
//

import SwiftUI

typealias CGOffset = CGSize

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

/// CGOffset extension adding support for addition operations between offsets.
extension CGOffset {
    static func + (lhs: CGOffset, rhs: CGOffset) -> CGOffset {
        CGOffset(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }
    static func += (lhs: inout CGOffset, rhs: CGOffset) {
        lhs = lhs + rhs
    }
}

/// String extension that returns a new string with duplicate characters removed.
extension String {
    var uniqued: String {
        reduce(into: "") { sofar, element in
            if !sofar.contains(element) {
                sofar.append(element)
            }
        }
    }
}

/// AnyTransition extension defining custom roll-up and roll-down view transitions.
extension AnyTransition {
    static let rollUp: AnyTransition = .asymmetric(
        insertion: .move(edge: .bottom),
        removal: .move(edge: .top)
    )
    static let rollDown: AnyTransition = .asymmetric(
        insertion: .move(edge: .top),
        removal: .move(edge: .bottom)
    )
}

/// A customizable button view that triggers its action with an animation.
struct AnimatedActionButton: View {
    var title: String? = nil
    var systemImage: String? = nil
    var role: ButtonRole? 
    let action: () -> Void

    init(
        _ title: String? = nil,
        systemImage: String? = nil,
        role: ButtonRole? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.systemImage = systemImage
        self.role = role
        self.action = action
    }

    var body: some View {
        Button(role: role) {
            withAnimation {
                action()
            }
        } label: {
            if let title, let systemImage {
                Label(title, systemImage: systemImage)
            } else if let title {
                Text(title)
            } else if let systemImage {
                Image(systemName: systemImage)
            }
        }
    }
}
