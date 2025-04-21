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
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        print("42")
        
        if let window = NSApplication.shared.windows.first {
            self.window = window
//            window.level = .floating
        }
    }
    
    private var aboutBoxWindowController: NSWindowController?
    
    func showAboutPanel() {
        if aboutBoxWindowController == nil {
            let styleMask: NSWindow.StyleMask = [.closable, .miniaturizable,/* .resizable,*/ .titled]
            let window = NSWindow()
            window.styleMask = styleMask
            window.title = "About My App"
            window.contentView = NSHostingView(rootView: AboutView())
            aboutBoxWindowController = NSWindowController(window: window)
        }
        
        aboutBoxWindowController?.showWindow(aboutBoxWindowController?.window)
    }
    
    func windowLevelToggle() {
        if window?.level == .floating {
            window?.level = .normal
        } else {
            window?.level = .floating
        }
        print(window?.level)
    }
}

struct AboutView: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text("Hello, World!")
                Spacer()
            }
            Spacer()
        }
        .frame(minWidth: 300, minHeight: 300)
    }
}
