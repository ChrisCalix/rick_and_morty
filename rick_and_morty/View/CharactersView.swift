//
//  ContentView.swift
//  rick_and_morty
//
//  Created by Sonic on 21/2/23.
//

import SwiftUI

struct CharactersView: View {
    @ObservedObject var viewModel = CharacterViewModel()
    
    private let columns = [
        GridItem(.adaptive(minimum: 170))
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(viewModel.characters, id: \.id) { character in
                    VStack {
                        Text(character.name)
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        HStack {
                            AsyncImage(url: URL(string: character.image)!) { image in
                                image.resizable()
                            } placeholder: {
                                Color.gray
                            }.frame(width: 100, height: 80)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            VStack {
                                Text(character.gender)
                                    .font(.caption2)
                                
                                Text(character.status)
                                    .font(.caption2)
                            }
                        }
                    }
                    .frame(width: 160 ,height: 80)
                    .padding(12)
                }
            }
        }.onAppear{
            viewModel.getAllCharacters()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CharactersView()
    }
}

fileprivate extension Image {
    func data(url: URL) -> Self {
        if let data = try? Data(contentsOf: url) {
            return Image(uiImage: UIImage(data: data)!)
                .resizable()
        }
        return self.resizable()
    }
}
