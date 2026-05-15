//
//  ContentView.swift
//  VKey
//
//  Created by Radomyr Sidenko on 21.04.2025.
//

import SwiftUI
import CoreGraphics

enum KeyboardLanguage: String {
    case en = "EN"
    case ru = "RU"
}

struct ContentView: View {
    @State private var language: KeyboardLanguage =
        KeyboardLanguage(rawValue: UserDefaults.standard.string(forKey: "keyboardLanguage") ?? "EN") ?? .en

    @State private var activePopup: ActiveAlternativePopup? = nil

    private var rows: [[KeyModel]] {
        switch language {
        case .en:
            return [
                "Q W E R T Y U I O P".split(separator: " ").map {
                    let label = String($0)
                    if label == "I" {
                        return KeyModel(label: label)
                    }
                    return KeyModel(label: label)
                },
                "A S D F G H J K L".split(separator: " ").map {
                    let label = String($0)
                    if label == "G" {
                        return KeyModel(label: label)
                    }
                    return KeyModel(label: label)
                },
                [
                    KeyModel(label: "🌐", width: 44),
                    KeyModel(label: "Z"),
                    KeyModel(label: "X"),
                    KeyModel(label: "C"),
                    KeyModel(label: "V"),
                    KeyModel(label: "B"),
                    KeyModel(label: "N"),
                    KeyModel(label: "M"),
                    KeyModel(label: "⌫", width: 56)
                ],
                [
                    KeyModel(label: "123", width: 52, alternatives: ["1", "2", "3"]),
                    KeyModel(label: "space", width: 180),
                    KeyModel(label: "return", width: 70)
                ]
            ]

        case .ru:
            return [
                "Й Ц У К Е Н Г Ш Щ З".split(separator: " ").map {
                    let label = String($0)
                    if label == "У" {
                        return KeyModel(label: label)
                    }
                    return KeyModel(label: label)
                },
                "Ф Ы В А П Р О Л Д".split(separator: " ").map {
                    let label = String($0)
                    if label == "А" {
                        return KeyModel(label: label)
                    }
                    return KeyModel(label: label)
                },
                [
                    KeyModel(label: "🌐", width: 44),
                    KeyModel(label: "Я"),
                    KeyModel(label: "Ч"),
                    KeyModel(label: "С"),
                    KeyModel(label: "М"),
                    KeyModel(label: "И"),
                    KeyModel(label: "Т"),
                    KeyModel(label: "Ь"),
                    KeyModel(label: "⌫", width: 56)
                ],
                [
                    KeyModel(label: "123", width: 52, alternatives: ["1", "2", "3"]),
                    KeyModel(label: "space", width: 180),
                    KeyModel(label: "return", width: 70)
                ]
            ]
        }
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(spacing: 8) {
                ForEach(rows.indices, id: \.self) { rowIndex in
                    HStack(spacing: 8) {
                        ForEach(Array(rows[rowIndex].enumerated()), id: \.element.id) { index, key in
                            KeyButton(
                                key: key,
                                placement: placement(for: index, in: rows[rowIndex].count),
                                direction: direction(for: rowIndex),
                                isActive: activePopup?.keyID == key.id,
                                onTap: { frame, tappedKey, placement, direction in
                                    handleTap(
                                        frame: frame,
                                        key: tappedKey,
                                        placement: placement,
                                        direction: direction
                                    )
                                }
                            )
                        }
                    }
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color(red: 0.12, green: 0.13, blue: 0.15))
            )
            .frame(minWidth: 500)

            if let popup = activePopup {
                alternativesOverlay(for: popup)
                    .zIndex(9999)
            }
        }
        .coordinateSpace(name: "keyboardSpace")
    }

    @ViewBuilder
    private func alternativesOverlay(for popup: ActiveAlternativePopup) -> some View {
        let xOffset: CGFloat
        switch popup.placement {
        case .left:
            xOffset = 44
        case .center:
            xOffset = 0
        case .right:
            xOffset = -44
        }

        let yOffset: CGFloat = popup.direction == .top ? -50 : 50

        return HStack(spacing: 8) {
            ForEach(Array(popup.alternatives.prefix(3)), id: \.self) { alt in
                Button {
                    typeString(alt.lowercased())
                    activePopup = nil
                } label: {
                    Text(alt)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 36, height: 36)
                        .background(Color(red: 0.18, green: 0.20, blue: 0.24))
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.14), lineWidth: 1)
                        )
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.black.opacity(0.35))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.25), radius: 12, y: 6)
        )
        .position(
            x: popup.frame.midX + xOffset,
            y: popup.frame.midY + yOffset
        )
    }

    private func handleTap(
        frame: CGRect,
        key: KeyModel,
        placement: AlternativePlacement,
        direction: AlternativeDirection
    ) {
        switch key.label {
        case "🌐":
            activePopup = nil
            language = (language == .en) ? .ru : .en
            UserDefaults.standard.set(language.rawValue, forKey: "keyboardLanguage")

        case "⌫":
            activePopup = nil
            simulateSpecialKeyPress(virtualKey: 51)

        case "space":
            activePopup = nil
            simulateSpecialKeyPress(virtualKey: 49)

        case "return":
            activePopup = nil
            simulateSpecialKeyPress(virtualKey: 36)

        case "123":
            if key.alternatives.isEmpty {
                activePopup = nil
            } else {
                activePopup = ActiveAlternativePopup(
                    keyID: key.id,
                    frame: frame,
                    alternatives: key.alternatives,
                    placement: placement,
                    direction: direction
                )
            }
            
        default:
            if key.alternatives.isEmpty {
                activePopup = nil
                typeString(key.label.lowercased())
            } else {
                if activePopup?.keyID == key.id {
                    activePopup = nil
                } else {
                    typeString(key.label.lowercased())
                    activePopup = ActiveAlternativePopup(
                        keyID: key.id,
                        frame: frame,
                        alternatives: key.alternatives,
                        placement: placement,
                        direction: direction
                    )
                }
            }
        }
    }

    private func direction(for rowIndex: Int) -> AlternativeDirection {
        rowIndex == 0 ? .bottom : .top
    }

    private func placement(for index: Int, in rowCount: Int) -> AlternativePlacement {
        if index <= 1 {
            return .left
        } else if index >= rowCount - 2 {
            return .right
        } else {
            return .center
        }
    }

    private func typeString(_ text: String) {
        for scalar in text.unicodeScalars {
            let string = String(scalar)
            let eventSource = CGEventSource(stateID: .hidSystemState)

            let down = CGEvent(keyboardEventSource: eventSource, virtualKey: 0, keyDown: true)
            down?.keyboardSetUnicodeString(stringLength: string.utf16.count, unicodeString: Array(string.utf16))
            down?.post(tap: .cghidEventTap)

            let up = CGEvent(keyboardEventSource: eventSource, virtualKey: 0, keyDown: false)
            up?.keyboardSetUnicodeString(stringLength: string.utf16.count, unicodeString: Array(string.utf16))
            up?.post(tap: .cghidEventTap)
        }
    }

    private func simulateSpecialKeyPress(virtualKey: CGKeyCode) {
        guard let source = CGEventSource(stateID: .hidSystemState) else { return }

        let keyDown = CGEvent(keyboardEventSource: source, virtualKey: virtualKey, keyDown: true)
        let keyUp = CGEvent(keyboardEventSource: source, virtualKey: virtualKey, keyDown: false)

        keyDown?.post(tap: .cghidEventTap)
        keyUp?.post(tap: .cghidEventTap)
    }
}
