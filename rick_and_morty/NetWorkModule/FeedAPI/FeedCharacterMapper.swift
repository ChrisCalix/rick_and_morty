//
//  FeedCharacterMapper.swift
//  rick_and_morty
//
//  Created by Sonic on 23/2/23.
//

import Foundation

enum FeedCharacterMapper {
    
    struct Root: Decodable {
        let id: Int
        let name: String
        let status: String
        let species: String
        let type: String
        let gender: String
        let origin: Direction
        let location: Direction
        let image: String
        let episode: [String]
        let url: String
        let created: String
        
        private enum CodingKeys: String, CodingKey {
            case id = "id"
            case name = "name"
            case status = "status"
            case species = "species"
            case type = "type"
            case gender = "gender"
            case origin = "origin"
            case location = "location"
            case image = "image"
            case episode = "episode"
            case url = "url"
            case created = "created"
        }
        
        struct Direction: Decodable {
            let name: String
            let url: String
            
            private enum CodingKeys: String, CodingKey {
                case name = "name"
                case url = "url"
            }
        }
    }
    
    private static let OK_200: Int = 200
    
    static func map(_ data: Data, response: HTTPURLResponse) -> RemoteFeedLoader.Result {
        guard response.statusCode == OK_200, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            return .failure(RemoteFeedLoader.Error.invalidData)
        }
        let character = FeedCharacter(id: root.id, name: root.name, status: root.status, species: root.species, type: root.type, gender: root.gender, origin: FeedCharacter.Direction(name: root.origin.name, url: root.origin.url), location: FeedCharacter.Direction(name: root.location.name, url: root.location.url), image: root.image, episode: root.episode, url: root.url, created: root.created)
        return .success(character)
    }
}
