//
//  PaintingView.swift
//  rick_and_morty
//
//  Created by Sonic on 24/2/23.
//

import SwiftUI

struct PaintingView: View {
    
    @ObservedObject var data: CharacterViewModel
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(self.data.characters) { character in
                ZStack {
                    AsyncImage(url: URL(string: character.image)!){ image in
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
