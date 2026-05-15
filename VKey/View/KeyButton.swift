//
//  KeyButton.swift
//  VKey
//
//  Created by Radomyr Sidenko on 15.05.2026.
//
import SwiftUI

struct KeyModel: Identifiable {
    let id = UUID()
    let label: String
    var width: CGFloat = 40
}

struct KeyButton: View {
    let key: KeyModel
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(key.label == "space" ? "Space" : key.label)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
                .frame(width: key.width, height: 40)
                .background(Color(red: 0.20, green: 0.22, blue: 0.25))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}
