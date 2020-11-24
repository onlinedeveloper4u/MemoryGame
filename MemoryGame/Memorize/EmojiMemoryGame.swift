//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Muhammad Aqib on 16/11/2020.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    @Published private var model: MemoryGame<String, Color> = EmojiMemoryGame.createMemoryGame()
    
    static func createMemoryGame() -> MemoryGame<String, Color> {
        let themes = [
            MemoryGame<String, Color>.Theme(name: "Flags", emojis: ["🇵🇰", "🇦🇫", "🇮🇶"], numberOfCards: 6, color: Color.green),
            MemoryGame<String, Color>.Theme(name: "Symbols", emojis: ["❤️", "🧡", "💚", "💙"], numberOfCards: 8, color: Color.pink),
            MemoryGame<String, Color>.Theme(name: "Objects", emojis: ["⌚️", "📱", "💻", "🖨", "📟"], numberOfCards: 10, color: Color.blue),
            MemoryGame<String, Color>.Theme(name: "Activity", emojis: ["⚽️", "🏀", "🏈", "🎱", "🥏", "🪀"], numberOfCards: 12, color: Color.gray),
            MemoryGame<String, Color>.Theme(name: "Food", emojis: ["🍇", "🍎", "🍐", "🍊", "🍋", "🍉", "🍓"], numberOfCards: 14, color: Color.red),
            MemoryGame<String, Color>.Theme(name: "Drink", emojis: ["🍝", "🍯", "🥛", "🧃", "🥤", "🍵", "🍷", "🍜"], numberOfCards: 16, color: Color.purple)
        ]
        let selectedTheme = themes[Int.random(in: 0..<themes.count)]
        return MemoryGame<String, Color>(theme: selectedTheme) { pairIndex in
            selectedTheme.emojis[pairIndex]
        }
    }
    
    // MARK: - Access to the Model
    
    var cards: Array<MemoryGame<String, Color>.Card> {
        model.cards
    }
    
    var theme: MemoryGame<String, Color>.Theme {
        model.theme
    }
    
    var score: Int {
        model.score
    }
    
    // MARK: - Intent(s)
    
    func choose(card: MemoryGame<String, Color>.Card) {
        model.choose(card: card)
    }
    
    func resetGame() {
        model = EmojiMemoryGame.createMemoryGame()
    }
}
