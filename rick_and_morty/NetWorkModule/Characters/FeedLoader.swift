//
//  FeedLoader.swift
//  rick_and_morty
//
//  Created by Sonic on 23/2/23.
//

import Foundation

protocol FeedLoader {
    associatedtype D
    typealias FeedResult = Swift.Result<D, Error>
    
    func load(completion: @escaping (FeedResult) -> Void)
}
