//
//  FeedMultipleCharacters.swift
//  rick_and_morty
//
//  Created by Sonic on 23/2/23.
//

import Foundation

struct Root: Decodable, Equatable {
    let results: [FeedCharacter]
}
