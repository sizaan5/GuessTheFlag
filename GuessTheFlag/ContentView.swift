//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Izaan Saleem on 24/01/2024.
//

import SwiftUI

struct FlagImage: View {
    var imageName: String
    var body: some View {
        Image(imageName)
            .clipShape(.ellipse)
            .shadow(radius: 10)
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score: Int = 0
    @State private var attempts: Int = 0
    @State private var selectedAnswer = ""
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.gray, .black], startPoint: .trailing, endPoint: .bottom)
            //RadialGradient(stops: [.init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3), .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.title2.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            attempts += 1
                            flagTapped(number)
                            selectedAnswer = countries[number]
                        } label: {
                            FlagImage(imageName: countries[number])
                        }
                        .alert(scoreTitle, isPresented: $showingScore) {
                            if attempts >= 8 {
                                Button("Reset", action: askQuestion)
                            } else {
                                Button("Continue", action: askQuestion)
                            }
                        } message: {
                            if attempts >= 8 {
                                Text("Your total score is: \(score)")
                            } else {
                                Text("That’s the flag of \(selectedAnswer)\nYour score is \(score)")
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.thinMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                Text("Attempts left: \(8 - attempts)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
    }
    
    func flagTapped(_ number: Int) {
        if attempts < 8 {
            if number == correctAnswer {
                scoreTitle = "Correct!"
                score += 1
            } else {
                scoreTitle = "Wrong!"
            }
        } else {
            scoreTitle = "Game Over!"
        }

        showingScore = true
    }
    
    func askQuestion() {
        if attempts >= 8 {
            score = 0
            attempts = 0
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
        } else {
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
        }
    }
}

#Preview {
    ContentView()
}
