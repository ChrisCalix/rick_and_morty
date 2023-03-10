//
//  CharacterModel.swift
//  rick_and_morty
//
//  Created by Sonic on 23/2/23.
//

import Foundation

struct CharacterModel : Decodable, Equatable, Identifiable {
    ///id    int    The id of the character.
    let id: Int
    ///name    string    The name of the character.
    let name: String
    ///status    string    The status of the character ('Alive', 'Dead' or 'unknown').
    let status: String
    ///species    string    The species of the character.
    let species: String
    ///type    string    The type or subspecies of the character.
    let type: String
    ///gender    string    The gender of the character ('Female', 'Male', 'Genderless' or 'unknown').
    let gender: String
    ///origin    object    Name and link to the character's origin location.
    let origin: Direction
    ///location    object    Name and link to the character's last known location endpoint.
    let location: Direction
    ///image    string (url)    Link to the character's image. All images are 300x300px and most are medium shots or portraits since they are intended to be used as avatars.
    let image: String
    ///episode    array (urls)    List of episodes in which this character appeared.
    let episode: [String]
    ///url    string (url)    Link to the character's own URL endpoint.
    let url: String
    ///created    string    Time at which the character was created in the database.
    let created: String
    
    struct Direction: Decodable, Equatable {
        let name: String
        let url: String
    }
}
