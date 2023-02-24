//
//  NetworkModule.swift
//  rick_and_mortyTests
//
//  Created by Sonic on 21/2/23.
//

import XCTest
@testable import rick_and_morty

class LoadSingleCharacterFromRemoteUseTestCase: NetworkTestCase<CharacterModel> {
    
    func test_singleCharacter_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()

        XCTAssertTrue(client.requestedURLs.isEmpty)
    }

    func test_singleCharacter_loadTwiceRequestDataFromURLTwice() {
        let url = URL(string: "https://rickandmortyapi.com/api/character/3")!
        let (sut, client) = makeSUT(url: url)

        sut.load { _ in }
        sut.load { _ in }

        XCTAssertEqual(client.requestedURLs, [url, url])
    }

    func test_singleCharacter_loadDeliversConnectivityErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(.connectivity), when: {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        })
    }

    func test_singleCharacter_loadDeliversInvalidDataErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()

        let samples = [199, 201, 300, 400, 500]

        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: .failure(.invalidData), when: {
                let json = makecharacterJSON()
                client.complete(withStatusCode: code, data: json, at: index)
            })
        }
    }

    func test_singleCharacter_loadDeliversInvalidDataErrorOn200HTTPResponseWithinvalidJSON() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: .failure(.invalidData), when: {
            let invalidJSON = Data("invalid JSON".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }
    
    func test_singleCharacter_loadDeliversSuccessWithNoItemsOn200HTTPResponseWithJSONItems() {
        let (sut, client) = makeSUT()
        
        let character = makeSingleCharacter()
        
        expect(sut, toCompleteWith: .success(character.model), when: {
            let json = makecharacterJSON(character.json)
            client.complete(withStatusCode: 200, data: json)
        })
    }
    
    // MARK: Helpers
    override func makeSUT(url: URL = URL(string: "https://rickandmortyapi.com/api/character/3")!, file: StaticString = #filePath, line: UInt = #line) -> (sut: RemoteFeedLoader<CharacterModel>, client: HTTPClientSpy) {
        super.makeSUT(url: url, file: file, line: line)
    }
    
    func makeSingleCharacter() -> (model: CharacterModel, json: [String: Any]) {
        
        let character = CharacterModel(id: 2, name: "Morty Smith", status: "Alive", species: "Human", type: "Alien", gender: "Male", origin: CharacterModel.Direction(name: "unknown", url: ""), location: CharacterModel.Direction(name: "Citadel of Ricks", url: "https://rickandmortyapi.com/api/location/3"), image: "https://rickandmortyapi.com/api/character/avatar/2.jpeg", episode: ["https://rickandmortyapi.com/api/episode/1", "https://rickandmortyapi.com/api/episode/1"], url: "https://rickandmortyapi.com/api/character/2", created: "2017-11-04T18:50:21.651Z")
        
        let jsonOrigin = [
            "name": character.origin.name,
            "url": character.origin.url
        ]
        let jsonLocation = [
            "name": character.location.name,
            "url": character.location.url
        ]
        let json : [String: Any]  = [
            "id": character.id,
            "name": character.name,
            "status": character.status,
            "species": character.species,
            "type": character.type,
            "gender": character.gender,
            "origin": jsonOrigin,
            "location": jsonLocation,
            "image": character.image,
            "episode": character.episode,
            "url": character.url,
            "created": character.created
        ].compactMapValues{ $0 }
        
        return (character, json)
    }
}
