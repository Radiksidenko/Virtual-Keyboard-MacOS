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
    
    private var rows: [[KeyModel]] {
        switch language {
        case .en:
            return [
                "Q W E R T Y U I O P".split(separator: " ").map { KeyModel(label: String($0)) },
                "A S D F G H J K L".split(separator: " ").map { KeyModel(label: String($0)) },
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
                    KeyModel(label: "123", width: 52),
                    KeyModel(label: "space", width: 180),
                    KeyModel(label: "return", width: 70)
                ]
            ]

        case .ru:
            return [
                "Й Ц У К Е Н Г Ш Щ З".split(separator: " ").map { KeyModel(label: String($0)) },
                "Ф Ы В А П Р О Л Д".split(separator: " ").map { KeyModel(label: String($0)) },
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
                    KeyModel(label: "123", width: 52),
                    KeyModel(label: "space", width: 180),
                    KeyModel(label: "return", width: 70)
                ]
            ]
        }
    }

    var body: some View {
        VStack(spacing: 8) {
            ForEach(rows.indices, id: \.self) { rowIndex in
                HStack(spacing: 8) {
                    ForEach(rows[rowIndex]) { key in
                        KeyButton(key: key) {
                            handleKeyPress(key)
                        }
                    }
                }
            }
        }
        .padding(12)
        .background(Color(red: 0.12, green: 0.13, blue: 0.15))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .frame(minWidth: 500)
    }
    
    private func handleKeyPress(_ key: KeyModel) {
        switch key.label {
        case "🌐":
            language = (language == .en) ? .ru : .en
            UserDefaults.standard.set(language.rawValue, forKey: "keyboardLanguage")
        case "⌫":
            simulateSpecialKeyPress(virtualKey: 51)
        case "space":
            simulateSpecialKeyPress(virtualKey: 49)
        case "return":
            simulateSpecialKeyPress(virtualKey: 36)
        case "123":
            break
        default:
            typeString(key.label.lowercased())
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
