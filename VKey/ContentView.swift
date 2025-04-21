//
//  ContentView.swift
//  VKey
//
//  Created by Radomyr Sidenko on 21.04.2025.
//

import SwiftUI
import Carbon
import CoreGraphics

struct ContentView: View {
//    @Environment(\.window) var window
    
    let appDelegate: AppDelegate
    
    var body: some View {
        VStack {
            KeyboardKey(char: "1", secondaryChar: "!", alignment: .center, secondaryCharAligment: .center, action: {
                let key = CGKeyCode(0)

                
                NSApp.windows.forEach { window in
                    window.ignoresMouseEvents = true
                    simulateKeyPress(virtualKey: key)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        window.ignoresMouseEvents = false
                    }
                }
                
            })
                .frame(width: 200, height: 200)
            
            KeyboardKey(char: "-", action: {
                appDelegate.windowLevelToggle()
//                appDelegate.window?.level = .normal
            })
                .frame(width: 200, height: 200)
        }
    }

    func simulateKeyPress(character: String) {
        guard let eventSource = CGEventSource(stateID: .hidSystemState) else {
            print("Не удалось создать источник события.")
            return
        }

        // Получаем виртуальный код клавиши для символа.
        // Этот способ может не работать для всех символов и раскладок.
        // Более надежный способ - использовать Text Input Source Services (TIS).
//        guard let key = keyFor(character: character) else {
//            print("Не удалось получить виртуальный код для символа: \(character)")
//            return
//        }
        
        
    }
    
    func simulateKeyPress(virtualKey: CGKeyCode) {
        guard let eventSource = CGEventSource(stateID: .hidSystemState) else {
            print("Не удалось создать источник события.")
            return
        }

        guard let keyDownEvent = CGEvent(keyboardEventSource: eventSource, virtualKey: virtualKey, keyDown: true) else {
            print("Не удалось создать событие key down.")
            return
        }

        keyDownEvent.post(tap: .cghidEventTap)

        guard let keyUpEvent = CGEvent(keyboardEventSource: eventSource, virtualKey: virtualKey, keyDown: false) else {
            print("Не удалось создать событие key up.")
            return
        }

        keyUpEvent.post(tap: .cghidEventTap)
    }
    
//    func keyFor(character: String) -> CGKeyCode? {
//        let layout = TISCopyCurrentKeyboardLayoutInputSource().takeUnretainedValue()
//        let layoutData = TISGetInputSourceProperty(layout, kTISPropertyUnicodeKeyLayoutData) as! CFData?
//        if let data = layoutData {
//            let keyboardLayout = UnsafePointer<UCKeyboardLayout>(CFDataGetBytePtr(data))
//            var deadKeyState: UInt32 = 0
//            var length = 0
//            var unicodeString = [UniChar](repeating: 0, count: 4)
//
//            let result = UCKeyTranslate(
//                keyboardLayout,
//                UInt16(character.utf16.first!),
//                UInt16(kUCKeyActionDown), // или kUCKeyActionDisplay
//                0, // modifierFlags
//                UInt32(LMGetKbdType()),
//                OptionBits(kUCKeyTranslateNoDeadKeysBit),
//                &deadKeyState,
//                4,
//                &length,
//                &unicodeString
//            )
//
//            if result == noErr && length > 0 {
//                // Теперь нам нужно преобразовать полученный Unicode в виртуальный код.
//                // Это более сложная задача и зависит от текущей раскладки.
//                // Для простых латинских букв можно попробовать прямой маппинг.
//                switch character.uppercased() {
//                case "A": return kVK_ANSI_A
//                case "B": return kVK_ANSI_B
//                case "C": return kVK_ANSI_C
//                case "D": return kVK_ANSI_D
//                case "E": return kVK_ANSI_E
//                case "F": return kVK_ANSI_F
//                case "G": return kVK_ANSI_G
//                case "H": return kVK_ANSI_H
//                case "I": return kVK_ANSI_I
//                case "J": return kVK_ANSI_J
//                case "K": return kVK_ANSI_K
//                case "L": return kVK_ANSI_L
//                case "M": return kVK_ANSI_M
//                case "N": return kVK_ANSI_N
//                case "O": return kVK_ANSI_O
//                case "P": return kVK_ANSI_P
//                case "Q": return kVK_ANSI_Q
//                case "R": return kVK_ANSI_R
//                case "S": return kVK_ANSI_S
//                case "T": return kVK_ANSI_T
//                case "U": return kVK_ANSI_U
//                case "V": return kVK_ANSI_V
//                case "W": return kVK_ANSI_W
//                case "X": return kVK_ANSI_X
//                case "Y": return kVK_ANSI_Y
//                case "Z": return kVK_ANSI_Z
//                case " ": return kVK_Space
//                default: return nil
//                }
//            }
//        }
//        return nil
//    }
}

#Preview {
    ContentView(appDelegate: AppDelegate())
}
