//
//  NetworkModule.swift
//  rick_and_mortyTests
//
//  Created by Sonic on 21/2/23.
//

import XCTest
@testable import rick_and_morty

class LoadCharacterFromRemoteUseTestCase: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()

        XCTAssertTrue(client.requestedURLs.isEmpty)
    }

    func test_loadTwice_requestDataFromURLTwice() {
        let url = URL(string: "https://rickandmortyapi.com/api/character/3")!
        let (sut, client) = makeSUT(url: url)

        sut.load { _ in }
        sut.load { _ in }

        XCTAssertEqual(client.requestedURLs, [url, url])
    }

    func test_deliversConnectivityErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(.connectivity), when: {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        })
    }

    func test_load_deliversInvalidDataErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()

        let samples = [199, 201, 300, 400, 500]

        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: .failure(.invalidData), when: {
                let json = makeItemsJSON()
                client.complete(withStatusCode: code, data: json, at: index)
            })
        }
    }

    func test_load_deliversInvalidDataErrorOn200HTTPResponseWithinvalidJSON() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: .failure(.invalidData), when: {
            let invalidJSON = Data("invalid JSON".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }
    
    func test_load_deliversSuccessWithNoItemsOn200HTTPResponseWithJSONItems() {
        let (sut, client) = makeSUT()
        
        let character = makeCharacter(id: 2, name: "Morty Smith", status: "Alive", species: "Human", gender: "Male", origin: FeedCharacter.Direction(name: "unknown", url: ""), location: FeedCharacter.Direction(name: "Citadel of Ricks", url: "https://rickandmortyapi.com/api/location/3"), image: "https://rickandmortyapi.com/api/character/avatar/2.jpeg", episode: ["https://rickandmortyapi.com/api/episode/1", "https://rickandmortyapi.com/api/episode/1"], url: "https://rickandmortyapi.com/api/character/2", created: "2017-11-04T18:50:21.651Z")
        
        expect(sut, toCompleteWith: .success(character.model), when: {
            let json = makeItemsJSON(character.json)
            client.complete(withStatusCode: 200, data: json)
        })
    }
    
//    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
//        let url = URL(string: "https://rickandmortyapi.com/api/character/3")!
//        let client = HTTPClientSpy()
//        var sut: RemoteFeedLoader? = RemoteFeedLoader(url: url, client: client)
//
//        var capturedResult : RemoteFeedLoader.Result?
//        sut?.load { capturedResult = $0 }
//
//        sut = nil
//        client.complete(withStatusCode: 200, data: makeItemsJSON())
//        XCTAssertNil(capturedResult)
//    }
    
    //MARK: Helpers
    private func makeSUT(url: URL = URL(string: "https://rickandmortyapi.com/api/character/3")!, file: StaticString = #filePath, line: UInt = #line) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        return (sut, client)
    }
    
    private func makeItemsJSON(_ character: [String: Any] = ["": ""]) -> Data {
        return try! JSONSerialization.data(withJSONObject: character)
    }
    
    private func makeCharacter(id: Int, name: String, status: String, species: String = "", type: String = "", gender: String = "", origin: FeedCharacter.Direction = FeedCharacter.Direction(name: "", url: ""), location: FeedCharacter.Direction = FeedCharacter.Direction(name: "", url: ""), image: String, episode: [String] = [], url: String, created: String = "") -> (model: FeedCharacter, json: [String: Any]) {
        
        let character = FeedCharacter(id: id, name: name, status: status, species: species, type: type, gender: gender, origin: origin, location: location, image: image, episode: episode, url: url, created: created)
        
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
    
    func expect(_ sut: RemoteFeedLoader, toCompleteWith expectedResult: Result<FeedCharacter, RemoteFeedLoader.Error>, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedChar), .success(expectedChar)):
                XCTAssertEqual(receivedChar, expectedChar, file: file, line: line)
            case let (.failure(receivedError as RemoteFeedLoader.Error), .failure(expectedError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        
        waitForExpectations(timeout: 0.1)
    }
}
