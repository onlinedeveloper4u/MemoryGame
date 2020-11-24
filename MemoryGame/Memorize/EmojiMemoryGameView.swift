//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Muhammad Aqib on 16/11/2020.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        VStack {
            HStack(alignment: VerticalAlignment.bottom, spacing: 50) {
                HStack {
                    Text("Theme: ")
                        .foregroundColor(viewModel.theme.color)
                    Text(viewModel.theme.name)
                        .foregroundColor(Color.secondary)
                }
                HStack {
                    Text("Score: ")
                        .foregroundColor(viewModel.theme.color)
                    Text("\(viewModel.score)")
                        .foregroundColor(Color.secondary)
                }
            }
            .font(Font.title)
            Grid(viewModel.cards) { card in
                CardView(card: card).onTapGesture {
                    withAnimation(.linear(duration: 0.75)) {
                        viewModel.choose(card: card)
                    }
                }
                .padding(5)
            }
            .padding()
            .foregroundColor(viewModel.theme.color)
            Button(action: {
                withAnimation(.easeInOut) {
                    viewModel.resetGame()
                }
            }, label: {
                Text("New Game")
            })
            .padding()
            .font(Font.title)
            .foregroundColor(viewModel.theme.color)
            .background(Color(UIColor.systemYellow))
            .cornerRadius(50)
        }
        .navigationBarTitle("Memory Game")
    }
}

struct CardView: View {
    var card: MemoryGame<String, Color>.Card
    
    var body: some View {
        GeometryReader { geometry in
            body(for: geometry.size)
        }
    }
    
    @State private var animatedBonusRemaining: Double = 0
    
    private func startBonusTimeAnimation() {
        animatedBonusRemaining = card.bonusRemaining
        withAnimation(.linear(duration: card.bonusTimeRemaining)) {
            animatedBonusRemaining = 0
        }
    }
    
    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {
            ZStack {
                Group {
                    if card.isConsumingBonusPoint {
                        Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-animatedBonusRemaining*360-90), clockwise: true)
                            .onAppear {
                                startBonusTimeAnimation()
                            }
                    }
                    else {
                        Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-card.bonusRemaining*360-90), clockwise: true)
                    }
                }
                .padding(5).opacity(0.4)
                .transition(.identity)
            Text(card.content)
                    .font(Font.system(size: fontSize(for: size)))
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(card.isMatched ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : .default)
            }
            .cardify(isFaceUp: card.isFaceUp)
            .transition(AnyTransition.scale)
        }
    }
    
    // MARK: - Drawing Constants
    
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.70
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(card: game.cards[0])
        return EmojiMemoryGameView(viewModel: game)
    }
}
