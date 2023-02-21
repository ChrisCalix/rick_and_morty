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
        client.get(from: url) { result in
            switch result {
            case .failure:
                completion(.failure(Error.connectivity))
            default: 
                completion(.failure(Error.unknown))
            }
            
        }
    }
    
}

protocol FeedLoader {
    typealias Result = Swift.Result<[FeedCharacter], Error>
    func load(completion: @escaping (Result) -> Void)
}

protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    func get(from url: URL, completion: @escaping (Result) -> Void)
}

struct FeedCharacter {
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
    let origin: AnyObject
    ///location    object    Name and link to the character's last known location endpoint.
    let location: AnyObject
    ///image    string (url)    Link to the character's image. All images are 300x300px and most are medium shots or portraits since they are intended to be used as avatars.
    let image: String
    ///episode    array (urls)    List of episodes in which this character appeared.
    let episode: [String]
    ///url    string (url)    Link to the character's own URL endpoint.
    let url: String
    ///created    string    Time at which the character was created in the database.
    let created: String
}
