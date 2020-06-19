//
//  AboutView.swift
//  bullseyeLearning
//
//  Created by wyn on 2020/2/22.
//  Copyright © 2020 Wyn. All rights reserved.
//

import SwiftUI
let beige = Color(red: 255.0 / 255.0, green: 214.0 / 255.0, blue: 179.0 / 255.0)


struct AboutHeadingStyle:ViewModifier{
    func body(content:Content)-> some View{
        return content
        .foregroundColor(Color.black)
        .font(Font.custom("ArialRoundedMTBold" , size: 30))
        .padding(.top, 20)
        .padding(.bottom, 20)
    }
}
struct AboutBodyStyle:ViewModifier{
    func body(content:Content)-> some View{
        return content
        .foregroundColor(Color.black)
        .font(Font.custom("ArialRoundedMTBold" , size: 16))
        .padding(.leading, 60)
        .padding(.trailing, 60)
        .padding(.bottom, 20)
    }
}
struct AboutView: View {
    var body: some View {
        Group{
        VStack{
            Text("🎯Bullseye🎯").modifier(AboutHeadingStyle())
            Text("This is bullseye, the game where you can win points and earn fame by dragging a slider").modifier(AboutBodyStyle())
            Text("Your goal is to place the slider as close as possible to the target value. The closer you are, the more points you score.").modifier(AboutBodyStyle())
            Text("Enjoy it!").modifier(AboutBodyStyle())
        }
        .navigationBarTitle("About Bullseye")
        .background(beige)
    }
    .background(Image("Background"))
}
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView().previewLayout(.fixed(width: 896, height: 414 ))
    }
}
