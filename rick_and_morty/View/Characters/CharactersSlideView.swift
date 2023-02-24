//
//  PlayerView.swift
//  rick_and_morty
//
//  Created by Sonic on 23/2/23.
//

import SwiftUI

struct CharactersSlideView: View {
    @ObservedObject var viewModel: CharacterViewModel
    @State var showLoading: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                if !viewModel.characters.isEmpty  {
                    PaintingScrollView(from: viewModel)
                        .offset(y: -25)
                        .onAppear {
                            showLoading = false
                    }
                }
                if showLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .scaleEffect(3)
                }
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .edgesIgnoringSafeArea(.all)
            .onAppear{
                showLoading = true
                viewModel.getAllCharacters()
            }
        }
        .alert("We have a rarely issue, please try again!", isPresented: $viewModel.showAlert,  actions: {
            
        })
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




