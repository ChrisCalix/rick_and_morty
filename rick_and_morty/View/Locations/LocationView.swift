//
//  Location.swift
//  rick_and_morty
//
//  Created by Sonic on 24/2/23.
//

import SwiftUI

struct LocationView: View {
    @ObservedObject var viewModel: LocationViewModel
    let urlLocation: URL
    
    var body: some View {
        VStack(spacing: 20) {
            if let location = viewModel.location {
                Text(location.name)
                    .font(.title)
                
                HStack(spacing: 20) {
                    Spacer(minLength: 5)
                    Text("Dimention:")
                        .frame(maxWidth: .infinity)
                    Text(location.dimension)
                        .frame(maxWidth: .infinity)
                    Spacer(minLength: 5)
                }
                
                HStack(spacing: 20) {
                    Spacer(minLength: 5)
                    Text("type:")
                        .frame(maxWidth: .infinity)
                    Text(location.type)
                        .frame(maxWidth: .infinity)
                    Spacer(minLength: 5)
                }
                
                Spacer()
                
            } else {
                Text("No hay location a mostrar")
            }
        }
        .onAppear() {
            viewModel.loadSingleLocation(url: urlLocation)
        }
        
    }
    
    init(from viewModel: LocationViewModel, urlLocation: URL) {
        self.viewModel = viewModel
        self.urlLocation = urlLocation
    }
}

struct Location_Previews: PreviewProvider {
    static var previews: some View {
        LocationView(from: LocationViewModel(), urlLocation: URL(string: "https://rickandmortyapi.com/api/location/3")!)
//        LocationView()
    }
}
