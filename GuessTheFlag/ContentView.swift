//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Bogdan Patynski on 2022-04-21.
//

import SwiftUI

extension Image {
    func flagImage() -> some View {
        self
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 10)
    }
}
 

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
        .font(.largeTitle)
        .foregroundColor(.white)
    } }

extension View {
    func titlestyle1() -> some View { self.modifier(Title())
        
    } }


struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var currentRound = 0
    @State private var roundDone = false
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func resetRound() {
        currentRound = 0
        score = 0
        
        askQuestion()
    }
    
    func flagTapped(_ number: Int) {
        if currentRound < 7 {
            if number == correctAnswer {
                        scoreTitle = "Correct"
                        score = score + 1
                    } else {
                        scoreTitle = "Wrong that's the flag of \(countries[number])"
            }

        showingScore = true
        currentRound += 1
        } else {
            roundDone = true
        }
    }
    

    
    var body: some View {
        
        ZStack{
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
                .ignoresSafeArea()

            VStack(spacing: 15) {
                Spacer()
                Text("Guess the Flag")
                        .titlestyle1()
                Spacer()
                Spacer()
                Text("Score: \(score)").titlestyle1()
                Spacer()
                VStack {
                        
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary).font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .foregroundColor(.white)
                            .font(.title
                            .bold())

                    }.frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .padding(.horizontal,20)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                    ForEach(0..<3) { number in
                        Button {
                           flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .flagImage()
                        }
                    }
            }.padding()
            
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(score)")
        }
        
        .alert("End of round", isPresented: $roundDone) {
            Button("Restart", action: resetRound)

        } message: {
            Text("Your total score is \(score)")
        }
        
            
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
