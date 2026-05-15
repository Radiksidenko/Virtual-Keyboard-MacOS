//
//  AppDelegate.swift
//  VKey
//
//  Created by Radomyr Sidenko on 21.04.2025.
//

import AppKit
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    
    var window: NSWindow?
    
    var statusItem: NSStatusItem!
    var myNonActivatingPanel: NSPanel?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "keyboard", accessibilityDescription: "VKey")
            button.target = self
            button.action = #selector(toggleKeyboardPanel)
        }
    }
    
    @objc func toggleKeyboardPanel() {
        if let panel = myNonActivatingPanel, panel.isVisible {
            panel.orderOut(nil)
        } else {
            showKeyboardPanel()
        }
    }
    
    func showKeyboardPanel() {
        let panel = NSPanel(
            contentRect: NSRect(x: 100, y: 550, width: 400, height: 250),
            styleMask: [.closable, .utilityWindow, .nonactivatingPanel, .resizable],
            backing: .buffered,
            defer: false
        )

        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        panel.isFloatingPanel = true
        panel.isMovable = true
        panel.isMovableByWindowBackground = true
        panel.minSize = NSSize(width: 500, height: 180)

        panel.setFrameAutosaveName("VKeyPanel")
        panel.setFrameUsingName("VKeyPanel")

        panel.contentView = NSHostingView(rootView: ContentView(panel: panel))
        panel.orderFront(nil)

        myNonActivatingPanel = panel
    }
}
