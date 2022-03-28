//
//  SloxApp.swift
//  Shared
//
//  Created by Patrick Van den Bergh on 26/03/2022.
//

import SwiftUI

@main
struct SloxApp: App {
    var body: some Scene {
        WindowGroup {
            #if os(macOS)
            ContentView().frame(minWidth: 600, maxWidth: .infinity, minHeight: 350, maxHeight: .infinity)
            #else
                ContentView()
            #endif
        }
    }
}
