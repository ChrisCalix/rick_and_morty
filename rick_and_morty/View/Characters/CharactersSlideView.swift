//
//  PlayerView.swift
//  rick_and_morty
//
//  Created by Sonic on 23/2/23.
//

import SwiftUI

struct CharactersSlideView: View {
    @ObservedObject var viewModel: CharacterViewModel
    
    var body: some View {
        ZStack {
            if !viewModel.characters.isEmpty  {
                PaintingScrollView(from: viewModel)
                    .offset(y: -25)
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .edgesIgnoringSafeArea(.all)
        .onAppear{
            viewModel.getAllCharacters()
        }
    }
    
    init(from viewModel: CharacterViewModel) {
        self.viewModel = viewModel
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        CharactersSlideView(from: CharacterViewModel())
    }
}



