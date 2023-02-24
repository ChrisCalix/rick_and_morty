//
//  BottomSheetDetailView.swift
//  rick_and_morty
//
//  Created by Sonic on 24/2/23.
//

import SwiftUI

struct BottomSheetDetailView: View {
    @ObservedObject var viewModel: CharacterViewModel
    
    var body: some View {
        if let characterSelected = viewModel.characterDetail {
            ScrollView{
                VStack {
                    HStack {
                        Text(characterSelected.name )
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                        
                        Spacer()
                        Text(characterSelected.status)
                            .font(.headline)
                            .fontWeight(.heavy)
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .foregroundColor(.white)
                            .background(characterSelected.status == "Alive" ? .green : .red)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                    .padding(.vertical, 20)
                    .padding(.trailing, 20)
                    .background(Color.cyan.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    VStack(spacing: 20) {
                        HStack(spacing: 20) {
                            Spacer(minLength: 5)
                            Text("Species:")
                                .frame(maxWidth: .infinity)
                            Text(characterSelected.species)
                                .frame(maxWidth: .infinity)
                            Spacer(minLength: 5)
                        }
                        
                        HStack(spacing: 20) {
                            Spacer(minLength: 5)
                            Text("Gender:")
                                .frame(maxWidth: .infinity)
                            Text(characterSelected.gender)
                                .frame(maxWidth: .infinity)
                            Spacer(minLength: 5)
                        }
                        
                        if !characterSelected.origin.name.isEmpty {
                            HStack(spacing: 20) {
                                Spacer(minLength: 5)
                                Text("Origin:")
                                    .frame(maxWidth: .infinity)
                                Text(characterSelected.origin.name)
                                    .frame(maxWidth: .infinity)
                                Spacer(minLength: 5)
                            }
                        }
                        
                        if !characterSelected.location.name.isEmpty {
                            HStack(spacing: 20) {
                                Spacer(minLength: 5)
                                Text("Location:")
                                    .frame(maxWidth: .infinity)
                                Text(characterSelected.location.name)
                                    .frame(maxWidth: .infinity)
                                Spacer(minLength: 5)
                            }
                        }

                    }.padding(.vertical, 10)
                    
                    Spacer()
                }
            }
        } else {
            Text("No se tiene descripcion del personaje")
                .font(.title)
        }
    }
    
    init(from viewModel: CharacterViewModel) {
        self.viewModel = viewModel
    }
}
