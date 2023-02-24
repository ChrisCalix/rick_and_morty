//
//  PaintingView.swift
//  rick_and_morty
//
//  Created by Sonic on 24/2/23.
//

import SwiftUI

struct PaintingView: View {
    
    @ObservedObject var viewModel: CharacterViewModel
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(self.viewModel.characters.enumerated()), id: \.element.id) { index, character in
                ZStack {
                    AsyncImage(url: URL(string: character.image)!){ image in
                        image.resizable()
                    } placeholder: {
                        Color.gray
                    }.frame(width: UIScreen.main.bounds.width, height:  UIScreen.main.bounds.height)
                    VStack {
                        HStack {
                            if index > 0 {
                                RoundedRectangle(cornerRadius: 50)
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.black.opacity(0.2))
                                    .padding(.leading)
                                    .overlay() {
                                        Image(systemName: "arrow.backward")
                                            .foregroundColor(.white)
                                            .fontWeight(.heavy)
                                            .padding(.leading)
                                            .font(.title2)
                                    }
                                
                            }
                            
                            Spacer()
                            
                            if index < viewModel.characters.count - 1 {
                                RoundedRectangle(cornerRadius: 50)
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.black.opacity(0.2))
                                    .padding(.trailing)
                                    .overlay() {
                                        Image(systemName: "arrow.forward")
                                            .foregroundColor(.white)
                                            .fontWeight(.heavy)
                                            .padding(.trailing)
                                            .font(.title2)
                                    }
                            }
                            
                        }
                        .padding(.top, 60)
                        Spacer()
                    }
                    
                    
                    CharacterOptionsView(from: viewModel, idCharacter: character.id, foreGroundColors: .black.opacity(0.8), backgroundColors: .white)
                }
                .sheet(isPresented: $viewModel.showingBottomDetailSheet) {
                    withAnimation {
                        BottomSheetDetailView(from: viewModel)
                            .presentationDetents([.height(110), .height(300)])
                            .presentationDragIndicator(.visible)
                    }
                   
                }
            }
        }
    }
    
    init(from viewModel: CharacterViewModel) {
        self.viewModel = viewModel
    }
}

struct PlayerV2iew_Previews: PreviewProvider {
    static var previews: some View {
        CharactersSlideView(from: CharacterViewModel())
    }
}
