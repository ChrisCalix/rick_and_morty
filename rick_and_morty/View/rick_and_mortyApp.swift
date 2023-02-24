//
//  rick_and_mortyApp.swift
//  rick_and_morty
//
//  Created by Sonic on 21/2/23.
//

import SwiftUI

@main
struct rick_and_mortyApp: App {
    @StateObject var networkMonitor = NetworkMonitor()
    
    var body: some Scene {
        WindowGroup {
            CharactersSlideView(from: CharacterViewModel())
                .environmentObject(networkMonitor)
        }
    }
}
