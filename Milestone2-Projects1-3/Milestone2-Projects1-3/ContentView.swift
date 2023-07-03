//
//  ContentView.swift
//  Milestone2-Projects1-3
//
//  Created by Ayşıl Simge Karacan on 1.07.2023.
//

import SwiftUI

struct ContentView: View {
    let rps = ["🪨", "📄", "✂️"]
    @State private var computerChoice = Int.random(in: 0..<3)
    @State private var scoreTitle = ""
    @State private var showingScore = false
    @State private var score = 0
    @State private var gameCount = 0
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.765, green: 0.216, blue: 0.392), Color(red: 0.114, green: 0.149, blue: 0.443)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Rock, Paper and Scissors")
                    .font(.largeTitle.weight(.heavy))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("Score: \(score)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                
                
                HStack(spacing: 20) {
                    ForEach(0..<3) { number in
                        Button("\(rps[number])") {
                            calculateWinner(number)
                        }
                    }
                    .font(.system(size: 100))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("App's Choice: \(rps[computerChoice])")
                    .font(.subheadline.weight(.heavy))
                    .foregroundColor(.white)
                

            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue") {
                computerChoice = Int.random(in: 0..<3)
                
                if gameCount == 0 {
                    score = 0
                }
            }
        } message: {
            Text("Your score is \(score)")
        }
    }
    
    func calculateWinner(_ userChoice: Int) {
        gameCount += 1

        if (computerChoice + 1) % 3 == userChoice {
            score += 1
            scoreTitle = "You won!"
        } else if computerChoice == userChoice {
            // It is a draw
            scoreTitle = "Draw"
        } else {
            scoreTitle = "You lost!"
            score -= 1
        }
        
        if gameCount == 10 {
            gameCount = 0
            scoreTitle = "Game Finished"
        }
        
        showingScore = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
