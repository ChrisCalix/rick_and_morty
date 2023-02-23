//
//  FeedLoader.swift
//  rick_and_morty
//
//  Created by Sonic on 23/2/23.
//

import Foundation

protocol FeedLoader {
    typealias Result = Swift.Result<FeedCharacter, Error>
    
    func load(completion: @escaping (Result) -> Void)
}
