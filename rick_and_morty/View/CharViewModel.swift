//
//  CharViewModel.swift
//  rick_and_morty
//
//  Created by Sonic on 23/2/23.
//

import Foundation

class CharViewModel: ObservableObject {
    @Published var char : [CharacterModel] = []
    
    init () {
        let remote = RemoteFeedLoader<[CharacterModel]>(url: URL(string: "https://rickandmortyapi.com/api/character/1,2,3")!, client: APIService())
        remote.load() { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(feed):
                DispatchQueue.main.async {
                    self.char = feed
                }
                
                print("succes \(feed)")
            case let .failure(error):
                print("error \(error)")
            }
        }
    }

}
