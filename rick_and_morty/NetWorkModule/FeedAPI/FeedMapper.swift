//
//  FeedMapper.swift
//  rick_and_morty
//
//  Created by Sonic on 23/2/23.
//

import Foundation

enum FeedMapper {
    private static let OK_200: Int = 200
    
    static func validateAndMap<T>(_ data: Data, response: HTTPURLResponse) -> RemoteFeedLoader<T>.FeedResult where T: Decodable {
        guard response.statusCode == OK_200, let root = try? JSONDecoder().decode(T.self, from: data) else {
            return .failure(RemoteFeedLoader<T>.Error.invalidData)
        }
        return .success(root)
    }
}



