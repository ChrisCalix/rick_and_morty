//
//  XCTestCase+makeCharacterJson.swift
//  rick_and_mortyTests
//
//  Created by Sonic on 23/2/23.
//

import XCTest

extension XCTestCase {
     func makecharacterJSON(_ character: [String: Any] = ["": ""]) -> Data {
        return try! JSONSerialization.data(withJSONObject: character)
    }
    
    func makecharactersJSON(_ characters: [[String: Any]]) -> Data {
        let json = characters
        return try! JSONSerialization.data(withJSONObject: json)
    }
}
