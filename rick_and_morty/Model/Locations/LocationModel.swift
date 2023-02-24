//
//  LocationModel.swift
//  rick_and_morty
//
//  Created by Sonic on 24/2/23.
//

import Foundation

struct LocationModel: Decodable, Equatable {
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [String]
    let created: String
}
