//
//  FeedLoader.swift
//  rick_and_morty
//
//  Created by Sonic on 23/2/23.
//

import Foundation

protocol FeedLoader {
    associatedtype T
    typealias FeedResult = Swift.Result<T, Error>
    
    func load(completion: @escaping (FeedResult) -> Void)
}
