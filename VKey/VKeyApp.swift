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
    
    
    @State var currentNumber: String = "1"
    @State var myNonActivatingPanel: NSPanel?
    
    @State private var isMenuVisible = false
    var body: some Scene {
        MenuBarExtra(currentNumber, systemImage: "\(currentNumber).circle") {
            Button("Toggle KeyBoard") {
                currentNumber = "1"
                if let myNonActivatingPanel = myNonActivatingPanel {
                    myNonActivatingPanel.close()
                    self.myNonActivatingPanel = nil
                } else {
                    showKeyboardPanel()
                }
            }
        }
        .menuBarExtraStyle(.menu)
    }
    
    func showKeyboardPanel() {
        let panel = NSPanel(
            contentRect: NSRect(x: 100, y: 550, width: 300, height: 200),
            styleMask: [.closable, .utilityWindow, .nonactivatingPanel],
//            styleMask: [.closable, .utilityWindow, .nonactivatingPanel, .titled, .resizable],
            backing: .buffered,
            defer: false
        )
        
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
//        panel.titlebarAppearsTransparent = true
//        panel.standardWindowButton(.closeButton)?.isHidden = true
        
        panel.isFloatingPanel = true
        panel.contentView = NSHostingView(rootView: ContentView())
        panel.orderFront(nil)
        
        myNonActivatingPanel = panel
    }
}
