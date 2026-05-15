//
//  Alternative.swift
//  VKey
//
//  Created by Radomyr Sidenko on 15.05.2026.
//

import SwiftUI

enum AlternativePlacement {
    case left
    case center
    case right
}

enum AlternativeDirection {
    case top
    case bottom
}

struct ActiveAlternativePopup: Equatable {
    let keyID: UUID
    let frame: CGRect
    let alternatives: [String]
    let placement: AlternativePlacement
    let direction: AlternativeDirection
}
