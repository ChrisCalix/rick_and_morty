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

        let exp = expectation(description: "Wait for load completion")

        sut.load { receivedResult in
            switch receivedResult {
            case let .failure(receivedError as RemoteFeedLoader.Error):
                XCTAssertEqual(receivedError, .connectivity)
            default:
                XCTFail("Expected Result instead")
            }
            exp.fulfill()
        }

        let clientError = NSError(domain: "Test", code: 0)
        client.complete(with: clientError)

        waitForExpectations(timeout: 1)
    }

    func test_load_deliversInvalidDataErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()

        let samples = [199, 201, 300, 400, 500]

        samples.enumerated().forEach { index, code in
            let exp = expectation(description: "Wait for load completion")
            sut.load { receivedResult in
                switch receivedResult {
                case let .failure(receivedError as RemoteFeedLoader.Error):
                    XCTAssertEqual(receivedError, .invalidData)
                default:
                    XCTFail("Expected Result instead")
                }
                exp.fulfill()
            }
            let json = makeItemsJSON()
            client.complete(withStatusCode: code, data: json, at: index)

            waitForExpectations(timeout: 1)
        }
    }

    func test_load_deliversInvalidDataErrorOn200HTTPResponseWithinvalidJSON() {
        let (sut, client) = makeSUT()

        let exp = expectation(description: "Wait for load completion")
        sut.load { receivedResult in
            switch receivedResult {
            case let .failure(receivedError as RemoteFeedLoader.Error):
                XCTAssertEqual(receivedError, .invalidData)
            default:
                XCTFail("Expected Result instead")
            }
            exp.fulfill()
        }

        let invalidJSON = Data("invalid JSON".utf8)
        client.complete(withStatusCode: 200, data: invalidJSON)

        waitForExpectations(timeout: 1)
    }
    
    func test_load_deliversSuccessWithNoItemsOn200HTTPResponseWithJSONItems() {
        let (sut, client) = makeSUT()
        
        let secondCharacter = makeCharacter(id: 2, name: "Morty Smith", status: "Alive", species: "Human", gender: "Male", origin: FeedCharacter.Direction(name: "unknown", url: ""), location: FeedCharacter.Direction(name: "Citadel of Ricks", url: "https://rickandmortyapi.com/api/location/3"), image: "https://rickandmortyapi.com/api/character/avatar/2.jpeg", episode: ["https://rickandmortyapi.com/api/episode/1", "https://rickandmortyapi.com/api/episode/1"], url: "https://rickandmortyapi.com/api/character/2", created: "2017-11-04T18:50:21.651Z")
        
        let exp = expectation(description: "Wait for load completion")
        sut.load { receivedResult in
            switch receivedResult {
            case let .failure(receivedError as RemoteFeedLoader.Error):
                XCTFail("Expected Result instead")
            case let .success(receivedCharacter):
                XCTAssertEqual(receivedCharacter, secondCharacter.model)
            default:
                XCTFail("Expected result instead")
            }
            exp.fulfill()
        }
        
        let json = makeItemsJSON(secondCharacter.json)
        client.complete(withStatusCode: 200, data: json)
        
        waitForExpectations(timeout: 1)
    }
    
    //MARK: Helpers
    
    private func makeSUT(url: URL = URL(string: "https://rickandmortyapi.com/api/character/3")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
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
    
    private class HTTPClientSpy: HTTPClient {
        private var messages = [(url: URL, completion: (HTTPClient.Result) -> Void)]()
        
        var requestedURLs: [URL] {
            return messages.map {$0.url}
        }
        
        func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            guard messages.count > index else {
                return XCTFail("Can't complete request neve made")
            }
            
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
            guard requestedURLs.count > index else {
                return XCTFail("Can't complete request never made")
            }
            
            let response = HTTPURLResponse(
                url: requestedURLs[index],
                statusCode: code,
                httpVersion: nil,
                headerFields: nil)!
            
            messages[index].completion(.success((data, response)))
        }
    }
}
