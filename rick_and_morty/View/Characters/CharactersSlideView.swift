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
                PlayerScrollView(viewModel: viewModel)
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



