//
//  TrafficLightButton.swift
//  VKey
//
//  Created by Radomyr Sidenko on 15.05.2026.
//

import SwiftUI

struct TrafficLightButton: View {
    enum Kind {
        case close
        case minimize

        var fill: Color {
            switch self {
            case .close: return Color(red: 0.93, green: 0.42, blue: 0.37)   // ~ #ed6a5f
            case .minimize: return Color(red: 0.96, green: 0.75, blue: 0.31) // ~ #f6be50
            }
        }

        var stroke: Color {
            switch self {
            case .close: return Color(red: 0.89, green: 0.29, blue: 0.25)
            case .minimize: return Color(red: 0.88, green: 0.65, blue: 0.24)
            }
        }

        var symbol: String {
            switch self {
            case .close: return "xmark"
            case .minimize: return "minus"
            }
        }
    }

    let kind: Kind
    let action: () -> Void
    @State private var isHovered = false

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(kind.fill)
                    .overlay(
                        Circle()
                            .stroke(kind.stroke, lineWidth: 0.5)
                    )
                    .frame(width: 12, height: 12)

                if isHovered {
                    Image(systemName: kind.symbol)
                        .font(.system(size: 7, weight: .bold))
                        .foregroundColor(.black.opacity(0.55))
                }
            }
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}
