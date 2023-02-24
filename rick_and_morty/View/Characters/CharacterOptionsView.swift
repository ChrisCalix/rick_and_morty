//
//  CharacterOptionsView.swift
//  rick_and_morty
//
//  Created by Sonic on 24/2/23.
//

import SwiftUI

struct CharacterOptionsView: View {
    @State var viewModel: CharacterViewModel
    @State var idCharacter: Int
    let foreGroundColors: Color
    let backgroundColors: Color
    
    var body: some View {
        VStack {
            
            Spacer()
            
            HStack(spacing: 20) {
                
                Spacer(minLength: 5)
                
                Button {
                    viewModel.toogleDetailState()
                    viewModel.getCharacterDescription(id: idCharacter)
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
    
    init(from viewModel: CharacterViewModel, idCharacter: Int, foreGroundColors: Color, backgroundColors: Color) {
        self.viewModel = viewModel
        self.foreGroundColors = foreGroundColors
        self.backgroundColors = backgroundColors
        self.idCharacter = idCharacter
    }
}
