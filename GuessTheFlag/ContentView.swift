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
            .clipShape(.capsule)
            .shadow(radius: 10)
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    let labels = [
        "Estonia": "Flag with three horizontal stripes. Top stripe blue, middle stripe black, bottom stripe white.",
        "France": "Flag with three vertical stripes. Left stripe blue, middle stripe white, right stripe red.",
        "Germany": "Flag with three horizontal stripes. Top stripe black, middle stripe red, bottom stripe gold.",
        "Ireland": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe orange.",
        "Italy": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe red.",
        "Nigeria": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe green.",
        "Poland": "Flag with two horizontal stripes. Top stripe white, bottom stripe red.",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red.",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background.",
        "Ukraine": "Flag with two horizontal stripes. Top stripe blue, bottom stripe yellow.",
        "US": "Flag with many red and white stripes, with white stars on a blue background in the top-left corner."
    ]
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score: Int = 0
    @State private var attempts: Int = 0
    @State private var selectedAnswer = ""
    @State private var animationAmount3D: [Double] = [0.0, 0.0, 0.0]
    @State private var buttonOpacities: [Double] = [1.0, 1.0, 1.0]
    @State private var buttonScales: [CGFloat] = [1.0, 1.0, 1.0]
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue, .black], startPoint: .top, endPoint: .bottom)
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
                    .accessibilityElement()
                    .accessibilityLabel("Tap the flag of \(countries[correctAnswer])")
                    
                    ForEach(0..<3) { number in
                        Button {
                            attempts += 1
                            flagTapped(number)
                            selectedAnswer = countries[number]
                            if number == correctAnswer {
                                withAnimation {
                                    animationAmount3D[number] += 360.0
                                    updateButtonStates(tappedButtonIndex: number)
                                    if attempts < 8 {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                            askQuestion()
                                        }
                                    }
                                }
                            }
                        } label: {
                            FlagImage(imageName: countries[number])
                        }
                        .accessibilityLabel(labels[countries[number], default: "Unknown Flag"])
                        .rotation3DEffect(
                            Angle(degrees: animationAmount3D[number]),
                            axis: (x: -1.0, y: 1.0, z: 20.0)
                        )
                        .opacity(buttonOpacities[number])
                        .scaleEffect(buttonScales[number])
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
        showingScore = false
        if attempts < 8 {
            if number == correctAnswer {
                scoreTitle = "Correct!"
                score += 1
            } else {
                scoreTitle = "Wrong!"
            }
        } else {
            showingScore = true
            score += 1
            scoreTitle = "Game Over!"
        }
    }
    
    func askQuestion() {
        resetButtonStates()
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
    
    func opacity(for number: Int) -> Double {
        return number != correctAnswer ? 0.25 : 1.0
    }
    
    
    func updateButtonStates(tappedButtonIndex: Int) {
        for index in 0..<buttonOpacities.count {
            buttonOpacities[index] = index == tappedButtonIndex ? 1.0 : 0.25
            buttonScales[index] = index == tappedButtonIndex ? 1.0 : 0.58
        }
    }
    
    func resetButtonStates() {
        withAnimation {
            animationAmount3D = [0.0, 0.0, 0.0]
            buttonOpacities = [1.0, 1.0, 1.0]
            buttonScales = [1.0, 1.0, 1.0]
        }
    }
}

#Preview {
    ContentView()
}
