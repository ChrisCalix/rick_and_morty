//
//  CharViewModel.swift
//  rick_and_morty
//
//  Created by Sonic on 23/2/23.
//

import Foundation

class CharacterViewModel: ObservableObject {
    
    @Published var characters : [CharacterModel] = []
    @Published var showingBottomDetailSheet: Bool = false
    @Published var characterDetail: CharacterModel?
    @Published var showAlert: Bool = false
    
    init () { }
    
    func toogleDetailState() {
        showingBottomDetailSheet.toggle()
    }
    
    func getCharacterDescription(id: Int) {
        characterDetail = characters
            .lazy
            .filter({ $0.id == id })
            .first
    }
    
    func getAllCharacters() {
        let remote = RemoteFeedLoader<AllCharacterModel>(url: URL(string: "https://rickandmortyapi.com/api/character")!, client: APIService())
        remote.load() { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(feed):
                DispatchQueue.main.async {
                    self.characters = feed.results
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.showAlert = true
                }
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
            case  .failure(_):
                DispatchQueue.main.async {
                    self.showAlert = true
                }
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
            case .failure(_):
                DispatchQueue.main.async {
                    self.showAlert = true
                }
            }
        }
    }
}

