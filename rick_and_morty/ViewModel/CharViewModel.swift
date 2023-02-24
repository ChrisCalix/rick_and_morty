//
//  CharViewModel.swift
//  rick_and_morty
//
//  Created by Sonic on 23/2/23.
//

import Foundation

class CharacterViewModel: ObservableObject {
    
    @Published var characters : [CharacterModel] = []
    
    init () { }
    
    func getAllCharacters() {
        let remote = RemoteFeedLoader<AllCharacterModel>(url: URL(string: "https://rickandmortyapi.com/api/character")!, client: APIService())
        remote.load() { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(feed):
                DispatchQueue.main.async {
                    self.characters = feed.results
                }
                
                print("succes \(feed)")
            case let .failure(error):
                print("error \(error)")
            }
        }
    }

    func getSingleCharacter(id: Int) {
        let remote = RemoteFeedLoader<[CharacterModel]>(url: URL(string: "https://rickandmortyapi.com/api/character/\(id)")!, client: APIService())
        remote.load() { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(feed):
                DispatchQueue.main.async {
                    self.characters = feed
                }
                
                print("succes \(feed)")
            case let .failure(error):
                print("error \(error)")
            }
        }
    }
    
    func getMultipleCharacter(ids: [Int]) {
        let strIds = ids.map { String($0) }.joined(separator: ", ")
        let remote = RemoteFeedLoader<[CharacterModel]>(url: URL(string: "https://rickandmortyapi.com/api/character/\(strIds)")!, client: APIService())
        remote.load() { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(feed):
                DispatchQueue.main.async {
                    self.characters = feed
                }
                
                print("succes \(feed)")
            case let .failure(error):
                print("error \(error)")
            }
        }
    }
}

