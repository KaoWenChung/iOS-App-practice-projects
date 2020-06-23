import SwiftUI

struct ContentView: View {
    
    @State var alertIsVisible = false
    @State var sliderValue = 50.0
    @State var target = Int.random(in: 1...100)
    @State var score = 0
    @State var round = 1
    let midnightBlue = Color(red: 0.0 / 255.0, green: 51.0 / 255.0, blue: 102.0 / 255.0)
    
    struct LabelStyle:ViewModifier{
        func body(content:Content)-> some View{
            return content
            .foregroundColor(Color.white)
            .modifier(Shadow())
            .font(Font.custom("ArialRoundedMTBold" , size: 18))
        }
    }
    struct ValueStyle:ViewModifier{
        func body(content:Content)-> some View{
            return content
            .foregroundColor(Color.yellow)
            .modifier(Shadow())
            .font(Font.custom("ArialRoundedMTBold" , size: 24))
        }
    }
    struct Shadow:ViewModifier{
        func body(content:Content)-> some View{
            return content
            .shadow(color: Color.black, radius: 5, x: 2, y: 2)
        }
    }
    struct ButtonLargeTextStyle:ViewModifier{
        func body(content:Content)-> some View{
            return content
            .foregroundColor(Color.black)
            .font(Font.custom("ArialRoundedMTBold" , size: 18))
            }
    }
    struct ButtonSmallTextStyle:ViewModifier{
        func body(content:Content)-> some View{
            return content
            .foregroundColor(Color.black)
            .font(Font.custom("ArialRoundedMTBold" , size: 12 ))
            }
    }
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Text("Put the Bullseye as close as you can to: ").modifier(LabelStyle())
                Text("\(target)").modifier(ValueStyle())
            }
            Spacer()
            HStack{
                Text("1").modifier(LabelStyle())
                Slider(value: $sliderValue, in:1...100).accentColor(Color.green)
                Text("100").modifier(LabelStyle())
            }
            Spacer()
            Button(action: {
                print("Button Press!")
                self.alertIsVisible = true
            }) {
                Text("Hit me").modifier(ButtonLargeTextStyle())
            }
            .alert(isPresented: $alertIsVisible){ ()-> Alert in
                return Alert(title: Text(alertTitle()), message: Text("The slider's value is \(sliderValueRounded()).\n" +
                "scored \(pointsForCurrentRound()) points this round."
                ), dismissButton: .default(Text("Awesome!")){
                    self.score = self.score + self.pointsForCurrentRound()
                    self.target = Int.random(in: 1...100)
                    self.round += 1
                    })
                }
            .background(Image("Button")).modifier(Shadow())
            Spacer()
            HStack{
                Button(action:{
                print("press Start Over!")
                    self.startNewGame()
                }){
                    HStack{
                    Image("StartOverIcon")
                    Text("Start Over").modifier(ButtonSmallTextStyle())
                    }}
                .background(Image("Button")).modifier(Shadow())
                Spacer()
                Text("Score:").modifier(LabelStyle())
                Text("\(score)").modifier(ValueStyle())
                Spacer()
                Text("Round:").modifier(LabelStyle())
                Text("\(round)").modifier(ValueStyle())
                Spacer()
                NavigationLink(destination: AboutView()){
                        HStack{
                            Image("InfoIcon")
                        Text("Info").modifier(ButtonSmallTextStyle())
                        }}
                    .background(Image("Button")).modifier(Shadow())
                    }     
            .padding(.bottom,20)
            }
        .background(Image("Background"), alignment: .center)
        .accentColor(midnightBlue)
        .navigationBarTitle("Bullseye")
}
    func sliderValueRounded()->Int{
        Int(sliderValue.rounded())
    }
    func amountOff()->Int{
        abs(target - sliderValueRounded())
    }
    func startNewGame(){
        score = 0
        round = 1
        sliderValue = 50.0
        target = Int.random(in: 1...100)
    }
    func pointsForCurrentRound()->Int{
        var points = 0
        if 100 - amountOff() == 100{
            points = 200
        }else if 100 - amountOff() == 99{
            points = 149
        }else{
            points = 100 - amountOff()
        }
        return points
    }
    func alertTitle()->String{
        let difference = amountOff()
        let title:String
        if difference == 0{
            title = "perfect!"
        }else if difference < 5 {
            title = "You almost had it!"
        }else if difference <= 10{
            title = "Not bad."
        }else{
            title = "Are you even trying?"
        }
        return title
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewLayout(.fixed(width: 896, height: 414 ))
    }
}
