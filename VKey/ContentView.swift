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
    
//    let appDelegate: AppDelegate
    
    @State var small: Bool = false
    
    @State private var panelPosition: NSPoint = NSPoint(x: 100, y: 100)
    @GestureState private var dragOffset: CGSize = .zero
    
    var body: some View {
//        VStack {
//            KeyboardKey(char: "1", secondaryChar: "!", alignment: .center, secondaryCharAligment: .center, action: {
//                let key = CGKeyCode(0)
//                simulateKeyPress(virtualKey: key)
//            })
//                .frame(width: 200, height: 200)
//            
//            KeyboardKey(char: "-", action: {
//            })
//                .frame(width: 200, height: 200)
//        }
        
        VStack {
            if small {
                KeyboardKey(char: "-", action: {
                    small.toggle()
                })
                
                VStack {
                    Text("Перетащите меня!")
                        .font(.headline)
                        .padding()
                    // Другой контент вашей панели
                }
                .frame(width: 200, height: 150)
                .background(Color.gray.opacity(0.3))
                .gesture(
                            DragGesture()
                                .updating($dragOffset) { value, state, transaction in
                                    state = value.translation
                                    updatePanelPosition(offset: state) // Обновляем положение во время движения
                                }
                                .onEnded { value in
                                    panelPosition.x += value.translation.width
                                    panelPosition.y -= value.translation.height
                                    updatePanelPosition(offset: .zero) // Финальное обновление после отпускания
                                }
                        )
                        .onAppear {
                            updatePanelPosition(offset: .zero) // Устанавливаем начальное положение
                        }
//                .gesture(
//                    DragGesture()
//                        .updating($dragOffset) { value, state, transaction in
//                            state = value.translation
//                        }
//                        .onEnded { value in
//                            panelPosition.x += value.translation.width
//                            panelPosition.y -= value.translation.height
//                            updatePanelPosition()
//                        }
//                )
//                .onAppear {
//                    updatePanelPosition()
//                }
                
            } else {
                VStack {
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(0..<6) { index in
                            HStack(spacing: 12) {
                                ForEach(keyboardData[index]) { keyData in
                                    switch keyData.type {
                                    case .normal:
                                        KeyboardKey(
                                            char: keyData.mainChar,
                                            secondaryChar: keyData.secondaryChar,
                                            alignment: keyData.mainCharAligment, secondaryCharAligment: keyData.secondaryCharAligment,
                                            buttonWidth: keyData.buttonWidth
                                        ) {
                                            let key = CGKeyCode(0)
                                            simulateKeyPress(virtualKey: key)
                                        }
                                        
                                    case .arrow:
                                        //                          ArrowKeyboardKey(
                                        //                            icon: keyData.mainChar,
                                        //                            topIcon: keyData.secondaryChar
                                        //                          )
                                        KeyboardKey(char: "-", action: {
                                            moveWindow()
                                        })
                                    case .fingerPrintScanner:
                                        KeyboardKey(char: "-", action: {small.toggle()})
                                    }
                                    
                                    
                                }
                            }
                        }
                    }
                    .padding(12)
                    .background(Color(hex: "#202226"))
                    .cornerRadius(16)
                    .shadow(color: .black, radius: 1, x: 0, y: -2)
                }
            }
      }
    }

    private func moveWindow() {
        if let panel = NSApplication.shared.windows.first(where: { ($0 as? NSPanel)?.contentView as? NSHostingView<Self> != nil }) as? NSPanel {
//                        panel.setFrameOrigin(panelPosition)
            if panel.styleMask.contains(.titled) {
                panel.styleMask.remove(.titled)
                panel.styleMask.remove(.resizable)
            } else {
                panel.styleMask.insert(.titled)
                panel.styleMask.insert(.resizable)
            }
        }
    }
    
    private func updatePanelPosition(offset: CGSize) {
            if let screen = NSScreen.main {
                let screenRect = screen.visibleFrame
                var newX = panelPosition.x + offset.width
                var newY = panelPosition.y - offset.height // Инвертируем Y

              

//                // Проверка выхода за границы экрана (по желанию)
//                if newX < screenRect.minX { newX = screenRect.minX }
//                if newX > screenRect.maxX { newX = screenRect.maxX }
//                if newY < screenRect.minY { newY = screenRect.minY }
//                if newY > screenRect.maxY { newY = screenRect.maxY }

                // Получаем доступ к NSPanel и обновляем его положение
                if let panel = NSApplication.shared.windows.first(where: { ($0 as? NSPanel)?.contentView as? NSHostingView<Self> != nil }) as? NSPanel {
                    panel.setFrameOrigin(NSPoint(x: newX, y: newY))
                }
            }
        }
    
    private func updatePanelPosition() {
        if let screen = NSScreen.main {
            print("Drag Offset Y: \(dragOffset.height)")
            print("Panel Position Y (before update): \(panelPosition.y)")
            
            let screenRect = screen.visibleFrame
            var newX = panelPosition.x + dragOffset.width
            var newY = panelPosition.y - dragOffset.height

            print("New Panel Position Y: \(newY)")
            
            
            
//            if newX < screenRect.minX { newX = screenRect.minX }
//            if newX > screenRect.maxX { newX = screenRect.maxX }
//            if newY < screenRect.minY { newY = screenRect.minY }
//            if newY > screenRect.maxY { newY = screenRect.maxY }

            panelPosition = NSPoint(x: newX, y: newY)

            // Получаем доступ к NSPanel и обновляем его положение
            if let panel = NSApplication.shared.windows.first(where: { ($0 as? NSPanel)?.contentView as? NSHostingView<Self> != nil }) as? NSPanel {
                panel.setFrameOrigin(panelPosition)
                
            }
        }
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
}

#Preview {
    ContentView()
}
