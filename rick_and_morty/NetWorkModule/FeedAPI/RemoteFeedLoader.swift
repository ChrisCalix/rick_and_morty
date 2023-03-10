//
//  RemoteFeedLoader.swift
//  rick_and_morty
//
//  Created by Sonic on 21/2/23.
//

import Foundation

class RemoteFeedLoader<T>: FeedLoader where T: Decodable {
    typealias D = T
    
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
    
    func load(completion: @escaping (FeedResult) -> Void) {
        client.get(from: url) { result in
            switch result {
            case let .success((data, response)):
                completion(FeedMapper.validateAndMap(data, response: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}
