//
//  RetroPlayerApp.swift
//  RetroPlayer
//
//  Created by Coni on 2025-06-29.
//

import SwiftUI

@main
struct RetroPlayerApp: App {
    var body: some Scene {
        WindowGroup("RetroMusic") {
            iPodView()
                .frame(width: 300, height: 300)
        }
        .windowResizability(.contentSize)
    }
}
