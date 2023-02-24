//
//  PlayerView.swift
//  rick_and_morty
//
//  Created by Sonic on 23/2/23.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel = CharacterViewModel()
    
    @State var index = 0
    @State var top = 0
    
    @State var data = [
        Picture(id: 0, picture: "https://rickandmortyapi.com/api/character/avatar/1.jpeg"),
        Picture(id: 1, picture: "https://rickandmortyapi.com/api/character/avatar/3.jpeg"),
        Picture(id: 2, picture: "https://rickandmortyapi.com/api/character/avatar/4.jpeg"),
        Picture(id: 3, picture: "https://rickandmortyapi.com/api/character/avatar/5.jpeg")
    ]
    
    var body: some View {
        ZStack {
            
            PlayerScrollView(data: self.$data)
                .offset(y: -25)
            
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .edgesIgnoringSafeArea(.all)
        .onAppear{
            viewModel.getAllCharacters()
        }
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct Picture: Identifiable {
    var id: Int
    var picture: String
}


struct PlayerView: View {
    
    @Binding var data : [ Picture ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(self.data) { picture in
                ZStack {
                    AsyncImage(url: URL(string: picture.picture)!){ image in
                        image.resizable()
                    } placeholder: {
                        Color.gray
                    }.frame(width: UIScreen.main.bounds.width, height:  UIScreen.main.bounds.height)
                    
                    CharacterOptions(foreGroundColors: .white, backgroundColors: .cyan)
                }
                
            }
        }
        
    }
}


struct PlayerScrollView: UIViewRepresentable {
    
    @Binding var data: [Picture]
    
    func makeUIView(context: Context) -> UIScrollView {
        let view = UIScrollView()
        let childView = UIHostingController(rootView: PlayerView(data: self.$data))
        
        childView.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * CGFloat((data.count)), height: UIScreen.main.bounds.height )
        
        view.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(data.count), height: UIScreen.main.bounds.height)
        
        view.addSubview(childView.view)
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        
        view.contentInsetAdjustmentBehavior = .never
        view.isPagingEnabled = true
        
        return view
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        
    }
}


struct CharacterOptions: View {
    
    let foreGroundColors: Color
    let backgroundColors: Color
    
    var body: some View {
        VStack {
            
            Spacer()
            
            HStack(spacing: 20) {
                
                Spacer(minLength: 5)
                
                Button {
                    
                } label: {
                    Text("DETALLES")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(foreGroundColors)
                        .fontWeight(.bold)
                        .padding(.all)
                }
                .buttonStyle(.borderedProminent)
                .tint(backgroundColors.opacity(0.8))
                
                Button {
                    
                } label: {
                    Text("EPISODIOS")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(foreGroundColors)
                        .fontWeight(.bold )
                        .padding(.all)
                }
                .buttonStyle(.borderedProminent)
                .tint(backgroundColors.opacity(0.8))
                
                Spacer(minLength: 5)
                
            }
            .padding(.bottom, 50)
        }
    }
}
