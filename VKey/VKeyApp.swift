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
        Settings {
            EmptyView()
        }
    }
}
