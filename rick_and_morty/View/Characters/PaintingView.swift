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
            ForEach(self.viewModel.characters) { character in
                ZStack {
                    AsyncImage(url: URL(string: character.image)!){ image in
                        image.resizable()
                    } placeholder: {
                        Color.gray
                    }.frame(width: UIScreen.main.bounds.width, height:  UIScreen.main.bounds.height)
                    
                    CharacterOptionsView(from: viewModel, idCharacter: character.id, foreGroundColors: .black.opacity(0.8), backgroundColors: .white)
                }
                .sheet(isPresented: $viewModel.showingBottomDetailSheet) {
                    BottomSheetDetailView(from: viewModel)
                        .presentationDetents([.height(110), .height(300)])
                        .presentationDragIndicator(.visible)
                }
            }
        }
    }
    
    init(from viewModel: CharacterViewModel) {
        self.viewModel = viewModel
    }
}

