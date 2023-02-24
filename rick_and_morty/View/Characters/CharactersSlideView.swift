//
//  PlayerView.swift
//  rick_and_morty
//
//  Created by Sonic on 23/2/23.
//

import SwiftUI

struct CharactersSlideView: View {
    @ObservedObject var viewModel = CharacterViewModel()
    
    var body: some View {
        ZStack {
            if !viewModel.characters.isEmpty  {
                PlayerScrollView(data: viewModel)
                    .offset(y: -25)
            }
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
        CharactersSlideView()
    }
}


struct PlayerScrollView: UIViewRepresentable {
    
    @ObservedObject var data: CharacterViewModel
    
    func makeUIView(context: Context) -> UIScrollView {
        let view = UIScrollView()
        let childView = UIHostingController(rootView: PaintingView(data: data))
        
        let cant = data.characters.count
        childView.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * CGFloat(cant), height: UIScreen.main.bounds.height )
        
        view.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(cant), height: UIScreen.main.bounds.height)
        
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
