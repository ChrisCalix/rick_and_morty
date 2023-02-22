//
//  RemoteFeedLoader.swift
//  rick_and_morty
//
//  Created by Sonic on 21/2/23.
//

import Foundation

class RemoteFeedLoader: FeedLoader {
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
        case unknown
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load(completion: @escaping (FeedLoader.Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success((data, response)):
                completion(FeedCharacterMapper.map(data, response: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
            
        }
    }
    
}

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

protocol FeedLoader {
    typealias Result = Swift.Result<FeedCharacter, Error>
    func load(completion: @escaping (Result) -> Void)
}

protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    func get(from url: URL, completion: @escaping (Result) -> Void)
}

struct FeedCharacter : Equatable {
    ///id    int    The id of the character.
    let id: Int
    ///name    string    The name of the character.
    let name: String
    ///status    string    The status of the character ('Alive', 'Dead' or 'unknown').
    let status: String
    ///species    string    The species of the character.
    let species: String
    ///type    string    The type or subspecies of the character.
    let type: String
    ///gender    string    The gender of the character ('Female', 'Male', 'Genderless' or 'unknown').
    let gender: String
    ///origin    object    Name and link to the character's origin location.
    let origin: Direction
    ///location    object    Name and link to the character's last known location endpoint.
    let location: Direction
    ///image    string (url)    Link to the character's image. All images are 300x300px and most are medium shots or portraits since they are intended to be used as avatars.
    let image: String
    ///episode    array (urls)    List of episodes in which this character appeared.
    let episode: [String]
    ///url    string (url)    Link to the character's own URL endpoint.
    let url: String
    ///created    string    Time at which the character was created in the database.
    let created: String
    
    struct Direction: Equatable {
        let name: String
        let url: String
    }
}
