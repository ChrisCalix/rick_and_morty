//
//  PlayerView.swift
//  rick_and_morty
//
//  Created by Sonic on 23/2/23.
//

import SwiftUI

struct CharactersSlideView: View {
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @State private var showNetworkAlert = false
    @State private var isLoading = false
    @ObservedObject var viewModel: CharacterViewModel
    
    var body: some View {
        if networkMonitor.isConnected {
            NavigationView {
                ZStack {
                    if !viewModel.characters.isEmpty  {
                        PaintingScrollView(from: viewModel)
                            .offset(y: -25)
                            .onAppear {
                                isLoading = false
                            }
                    }
                    
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                            .scaleEffect(3)
                    }
                }
                .background(Color.black.edgesIgnoringSafeArea(.all))
                .edgesIgnoringSafeArea(.all)
                .onAppear{
                    viewModel.getAllCharacters()
                    isLoading = true
                }
            }
            .onChange(of: networkMonitor.isConnected) { newValue in
                showNetworkAlert = newValue == false
            }
            .alert("Network connection seems to be offline", isPresented: $showNetworkAlert) {
                
            }
        } else {
            HStack(alignment: .center) {
                Text("You dont have connection. Please check your internet and try again!")
            }
        }
       
    }
    
    init(from viewModel: CharacterViewModel) {
        self.viewModel = viewModel
    }

}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        CharactersSlideView(from: CharacterViewModel())
            .environmentObject(NetworkMonitor())
    }
}




