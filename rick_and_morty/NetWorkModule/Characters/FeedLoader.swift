//
//  FeedLoader.swift
//  rick_and_morty
//
//  Created by Sonic on 23/2/23.
//

import Foundation

protocol FeedLoader {
    typealias SingleResult = Swift.Result<FeedCharacter, Error>
    typealias MultipleResult = Swift.Result<[FeedCharacter], Error>
    
    func loadSingleCharacter(completion: @escaping (SingleResult) -> Void)
    func loadMultipleCharacters(completion: @escaping (MultipleResult) -> Void)
}
