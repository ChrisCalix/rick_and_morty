//
//  LoadMultipleCharacterFromRemoteUseTestCase.swift
//  rick_and_mortyTests
//
//  Created by Sonic on 23/2/23.
//

import XCTest
@testable import rick_and_morty

class LoadMultipleCharacterFromRemoteUseTestCase: NetworkTestCase<[CharacterModel]> {

    func test_multipleCharacter_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()

        XCTAssertTrue(client.requestedURLs.isEmpty)
    }

    func test_multipleCharacter_loadTwiceRequestDataFromURLTwice() {
        let url = URL(string: "https://rickandmortyapi.com/api/character/1,2,3")!
        let (sut, client) = makeSUT(url: url)

        sut.load { _ in }
        sut.load { _ in }

        XCTAssertEqual(client.requestedURLs, [url, url])
    }

    func test_multipleCharacter_loadDeliversConnectivityErrorOnClientError() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: .failure(.connectivity), when: {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        })
    }

    func test_multipleCharacter_loadDeliversInvalidDataErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()

        let samples = [199, 201, 300, 400, 500]

        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: .failure(.invalidData), when: {
                let json = makecharacterJSON()
                client.complete(withStatusCode: code, data: json, at: index)
            })
        }
    }

    func test_multipleCharacter_loadDeliversInvalidDataErrorOn200HTTPResponseWithinvalidJSON() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: .failure(.invalidData), when: {
            let invalidJSON = Data("invalid JSON".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }
    
    func test_multipleCharacter_loadDeliversSuccessWithNoItemsOn200HTTPResponseWithJSONItems() {
        let (sut, client) = makeSUT()
        
        let character1 = makeSingleCharacter(id: 2, name: "Morty Smith", status: "Alive", species: "Human", gender: "Male", origin: CharacterModel.Direction(name: "unknown", url: ""), location: CharacterModel.Direction(name: "Citadel of Ricks", url: "https://rickandmortyapi.com/api/location/3"), image: "https://rickandmortyapi.com/api/character/avatar/2.jpeg", episode: ["https://rickandmortyapi.com/api/episode/1", "https://rickandmortyapi.com/api/episode/1"], url: "https://rickandmortyapi.com/api/character/2", created: "2017-11-04T18:50:21.651Z")
        
        let character2 = makeSingleCharacter(id: 2, name: "Morty Smith", status: "Alive", species: "Human", gender: "Male", origin: CharacterModel.Direction(name: "unknown", url: ""), location: CharacterModel.Direction(name: "Citadel of Ricks", url: "https://rickandmortyapi.com/api/location/3"), image: "https://rickandmortyapi.com/api/character/avatar/2.jpeg", episode: ["https://rickandmortyapi.com/api/episode/1", "https://rickandmortyapi.com/api/episode/1"], url: "https://rickandmortyapi.com/api/character/2", created: "2017-11-04T18:50:21.651Z")
        
        let chars = [character1.model, character2.model]
        expect(sut, toCompleteWith: .success(chars), when: {
            let json = makecharactersJSON([character1.json, character2.json])
            client.complete(withStatusCode: 200, data: json)
        })
    }
    
    //MARK: Helpers
    override func makeSUT(url: URL = URL(string: "https://rickandmortyapi.com/api/character/1,2,3")!, file: StaticString = #filePath, line: UInt = #line) -> (sut: RemoteFeedLoader<[CharacterModel]>, client: HTTPClientSpy) {
        super.makeSUT(url: url, file: file, line: line)
    }
    
    func makecharactersJSON(_ characters: [[String: Any]]) -> Data {
        let json = characters
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    func makeSingleCharacter(id: Int, name: String, status: String, species: String = "", type: String = "", gender: String = "", origin: CharacterModel.Direction = CharacterModel.Direction(name: "", url: ""), location: CharacterModel.Direction = CharacterModel.Direction(name: "", url: ""), image: String, episode: [String] = [], url: String, created: String = "") -> (model: CharacterModel, json: [String: Any]) {
        
        let character = CharacterModel(id: id, name: name, status: status, species: species, type: type, gender: gender, origin: origin, location: location, image: image, episode: episode, url: url, created: created)
        
        let jsonOrigin = [
            "name": origin.name,
            "url": origin.url
        ]
        let jsonLocation = [
            "name": location.name,
            "url": location.url
        ]
        let json : [String: Any]  = [
            "id": id,
            "name": name,
            "status": status,
            "species": species,
            "type": type,
            "gender": gender,
            "origin": jsonOrigin,
            "location": jsonLocation,
            "image": image,
            "episode": episode,
            "url": url,
            "created": created
        ].compactMapValues{ $0 }
        
        return (character, json)
    }
}
