//
//  KeyButton.swift
//  VKey
//
//  Created by Radomyr Sidenko on 15.05.2026.
//

import SwiftUI

struct KeyModel: Identifiable, Equatable {
    let id = UUID()
    let label: String
    var width: CGFloat = 40
    var alternatives: [String] = []
}

struct KeyButton: View {
    let key: KeyModel
    let placement: AlternativePlacement
    let direction: AlternativeDirection
    let isActive: Bool
    let onTap: (CGRect, KeyModel, AlternativePlacement, AlternativeDirection) -> Void

    var body: some View {
        GeometryReader { proxy in
            Button {
                let frame = proxy.frame(in: .named("keyboardSpace"))
                onTap(frame, key, placement, direction)
            } label: {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: key.width, height: 40)
                    .background(
                        isActive
                        ? Color.green.opacity(0.85)
                        : Color(red: 0.20, green: 0.22, blue: 0.25)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(Color.white.opacity(isActive ? 0.20 : 0.08), lineWidth: 1)
                    )
            }
            .buttonStyle(.plain)
        }
        .frame(width: key.width, height: 40)
    }

    private var title: String {
        switch key.label {
        case "space":
            return "Space"
        case "return":
            return "Return"
        default:
            return key.label
        }
    }
}
