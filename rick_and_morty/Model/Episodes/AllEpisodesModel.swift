//
//  AllEpisodesModel.swift
//  rick_and_morty
//
//  Created by Sonic on 23/2/23.
//

import Foundation

struct AllEpisodesModel: Decodable, Equatable {
    
    let results: [EpisodeModel]
    
}
