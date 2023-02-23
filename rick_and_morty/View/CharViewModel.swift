//
//  CharViewModel.swift
//  rick_and_morty
//
//  Created by Sonic on 23/2/23.
//

import Foundation

class CharViewModel: ObservableObject {
    @Published var char : [FeedCharacter] = []
    
    init () {
        let remote = RemoteFeedLoader<FeedCharacter>(url: URL(string: "https://rickandmortyapi.com/api/character/3")!, client: APIService())
        remote.load() { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(feed):
                self.char = [feed]
                print("succes \(feed)")
            case let .failure(error):
                print("error \(error)")
            }
        }
    }

}