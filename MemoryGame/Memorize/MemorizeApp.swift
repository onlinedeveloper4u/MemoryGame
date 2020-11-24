//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Muhammad Aqib on 16/11/2020.
//

import SwiftUI

@main
struct MemorizeApp: App {
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(viewModel: EmojiMemoryGame())
        }
    }
}
