//
//  ContentView.swift
//  SwiftUILearning
//
//  Created by wyn on 2020/4/14.
//  Copyright © 2020 Wyn. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Your time is limited, so don’t waste it living someone else’s life. Don’t be trapped by dogma—which is living with the results of other people’s thinking. Don’t let the noise of others’ opinions drown out your own inner voice. And most important, have the courage to follow your heart and intuition." )
            .fontWeight(.bold)
            .font(.custom("Helvetica Neue", size: 20))
            .foregroundColor(.purple)
            .multilineTextAlignment(.center)
//            .lineLimit(3)
            .truncationMode(.head)
            .lineSpacing(10)
            .padding()
            .rotation3DEffect(.degrees(20), axis:(x: 0, y:50, z:50))
            .shadow(color: .gray, radius:5, x: 0, y:5)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
