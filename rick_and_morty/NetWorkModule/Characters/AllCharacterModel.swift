//
//  FeedMultipleCharacters.swift
//  rick_and_morty
//
//  Created by Sonic on 23/2/23.
//

import Foundation

struct AllCharacterModel: Decodable, Equatable {
    let results: [CharacterModel]
}
