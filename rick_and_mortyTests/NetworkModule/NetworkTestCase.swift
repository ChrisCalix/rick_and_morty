//
//  NetworkTestCase.swift
//  rick_and_mortyTests
//
//  Created by Sonic on 23/2/23.
//

import XCTest
@testable import rick_and_morty

typealias NetworkModuleConditions = Decodable & Equatable

class NetworkTestCase<T: NetworkModuleConditions>: XCTestCase {
    
    //MARK: Helpers
    func makeSUT(url: URL, file: StaticString = #filePath, line: UInt = #line) -> (sut: RemoteFeedLoader<T>, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader<T>(url: url, client: client)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        return (sut, client)
    }
    
    func expect(_ sut: RemoteFeedLoader<T>, toCompleteWith expectedResult: Result<T, RemoteFeedLoader<T>.Error>, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedChar), .success(expectedFeed)):
                XCTAssertEqual(receivedChar, expectedFeed, file: file, line: line)
            case let (.failure(receivedError as RemoteFeedLoader<T>.Error), .failure(expectedError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        
        waitForExpectations(timeout: 0.1)
    }
    
    func makeSingleCharacter(id: Int, name: String, status: String, species: String = "", type: String = "", gender: String = "", origin: FeedCharacter.Direction = FeedCharacter.Direction(name: "", url: ""), location: FeedCharacter.Direction = FeedCharacter.Direction(name: "", url: ""), image: String, episode: [String] = [], url: String, created: String = "") -> (model: FeedCharacter, json: [String: Any]) {
        
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
    
    func makecharacterJSON(_ character: [String: Any] = ["": ""]) -> Data {
        return try! JSONSerialization.data(withJSONObject: character)
    }
}
