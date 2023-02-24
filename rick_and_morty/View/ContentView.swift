//
//  ContentView.swift
//  rick_and_morty
//
//  Created by Sonic on 21/2/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var chars = CharViewModel()
    
    var body: some View {
        ScrollView {
            ForEach(chars.char) { char in
                HStack {
                    Text(char.name)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text(char.species)
                        Text(char.gender)
                    }
                }
                .frame(height: 80)
                .padding(12)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
