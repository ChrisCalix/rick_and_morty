//
//  EpisodeModel.swift
//  rick_and_morty
//
//  Created by Sonic on 23/2/23.
//

import Foundation

struct EpisodeModel: Decodable, Equatable, Identifiable {
    
    let id: Int
    let name: String
    let air_date: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
    
}
