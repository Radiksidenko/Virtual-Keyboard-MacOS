//
//  VKeyApp.swift
//  VKey
//
//  Created by Radomyr Sidenko on 21.04.2025.
//

import SwiftUI
import AppKit

@main
struct VKeyApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView(appDelegate: appDelegate)
                .onAppear {
                    NSApp.windows.forEach { window in
                        window.isMovableByWindowBackground = true
                        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
                        window.level = .floating
                        window.isOpaque = false
                        window.backgroundColor = .clear
//                        window.ignoresMouseEvents = true // Пока оставляем так, обсудим позже
                    }
                }
        }
//        .commands {
//            CommandGroup(replacing: CommandGroupPlacement.appInfo) {
//                Button(action: {
//                    appDelegate.showAboutPanel()
//                }) {
//                    Text("About My App")
//                }
//            }
//        }
    }
}
