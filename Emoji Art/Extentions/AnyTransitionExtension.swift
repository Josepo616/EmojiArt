//
//  File.swift
//  Emoji Art
//
//  Created by JoseAlvarez on 8/18/25.
//

import SwiftUI

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
