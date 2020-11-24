//
//  MemoryGame.swift
//  Memorize
//
//  Created by Muhammad Aqib on 16/11/2020.
//

import Foundation

struct MemoryGame<CardContent, ThemeColor> where CardContent: Equatable {
    private (set) var cards: Array<Card>
    
    private(set) var theme: Theme
    
    private(set) var score: Int = 0
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter { cards[$0].isFaceUp }.only }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = index == newValue
            }
        }
    }
    
    mutating func choose(card: Card) {
        if let chosenIndex = cards.firstIndex(matching: card), !cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched {
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    score = score + max(maxBonusPoints-Int(cards[potentialMatchIndex].faceUpTime), 1)
                }
                else {
                    for index in [chosenIndex, potentialMatchIndex] {
                        if cards[index].isSeen {
                            score -= 1
                        }
                        else {
                            for cardIndex in cards.indices {
                                if cards[index].content == cards[cardIndex].content {
                                    cards[cardIndex].isSeen = true
                                }
                            }
                        }
                    }
                }
                cards[chosenIndex].isFaceUp = true
            }
            else {
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
        }
    }
    
    init(theme: Theme, cardContentFactory: (Int) -> CardContent) {
        self.theme = Theme(name: theme.name, emojis: theme.emojis, numberOfCards: theme.numberOfCards, color: theme.color)
        cards = Array<Card>()
        for pairIndex in 0..<theme.numberOfCards/2 {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2+1))
        }
        cards.shuffle()
    }
     
    struct  Card: Identifiable {
        var isFaceUp: Bool = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                }
                else {
                    stopUsingBonusPoint()
                }
            }
        }
        
        var isMatched: Bool = false {
            didSet {
                if isMatched {
                    stopUsingBonusPoint()
                }
            }
        }
        
        var isSeen: Bool = false
        
        var content: CardContent
        var id: Int
        
        // MARK: - Bonus Time
        
        // this could give matching bonus points
        // if the user matches the card
        // before a certain amount of time passes during which the card is face up
        
        // can be zero which means "no bonus available" for this card
        var bonusTimeLimit: TimeInterval = 6
        
        // how long this card has ever been face up
        fileprivate var faceUpTime: TimeInterval {
            if let lastFaceUpDate = lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            }
            else {
                return pastFaceUpTime
            }
        }
        // the last time this card was turned face up (and is still face up)
        var lastFaceUpDate: Date?
        // the accumulated time this card has been face up in the past
        // (i.e. not including the current time it's been face up if it is currently so)
        var pastFaceUpTime: TimeInterval = 0
        
        // how much time left before bonus opportunity runs out
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit-faceUpTime)
        }
        // percentage of the bonus time remaining
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining / bonusTimeLimit : 0
        }
        // whether the card was matched during the bonus time period
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        // whether we are currently face up, unmatched and have not yet used up the bonus window
        var isConsumingBonusPoint: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        
        // called when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isConsumingBonusPoint, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        // called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusPoint() {
            pastFaceUpTime = faceUpTime
            lastFaceUpDate = nil
        }
    }
    
    struct Theme {
        var name: String
        var emojis: [String]
        var numberOfCards: Int
        var color: ThemeColor
    }
    
    // MARK: - Drawing Constants
    
    let maxBonusPoints: Int = 5
}
