//
//  LoadSingleLocationFromRemoteUseTestCase.swift
//  rick_and_mortyTests
//
//  Created by Sonic on 24/2/23.
//

import XCTest
@testable import rick_and_morty

class LoadSingleLocationFromRemoteUseTestCase: NetworkTestCase<LocationModel> {
    
    func test_singleLocation_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()

        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_singleLocation_loadTwiceRequestDataFromURLTwice() {
        let url = URL(string: "https://rickandmortyapi.com/api/episode/28")!
        let (sut, client) = makeSUT(url: url)

        sut.load { _ in }
        sut.load { _ in }

        XCTAssertEqual(client.requestedURLs, [url, url])
    }

    func test_singleLocation_loadDeliversConnectivityErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(.connectivity), when: {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        })
    }

    func test_singleLocation_loadDeliversInvalidDataErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()

        let samples = [199, 201, 300, 400, 500]

        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: .failure(.invalidData), when: {
                let json = makecharacterJSON()
                client.complete(withStatusCode: code, data: json, at: index)
            })
        }
    }

    func test_singleLocation_loadDeliversInvalidDataErrorOn200HTTPResponseWithinvalidJSON() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: .failure(.invalidData), when: {
            let invalidJSON = Data("invalid JSON".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }
    
    func test_singleLocation_loadDeliversSuccessWithNoItemsOn200HTTPResponseWithJSONItems() {
        let (sut, client) = makeSUT()
        
        let episode = makeSimpleLocation()
        
        expect(sut, toCompleteWith: .success(episode.model), when: {
            let json = makecharacterJSON(episode.json)
            client.complete(withStatusCode: 200, data: json)
        })
    }
    
    override func makeSUT(url: URL = URL(string: "https://rickandmortyapi.com/api/location/3")!, file: StaticString = #filePath, line: UInt = #line) -> (sut: RemoteFeedLoader<LocationModel>, client: HTTPClientSpy) {
        super.makeSUT(url: url, file: file, line: line)
    }
    
    func makeSimpleLocation() -> (model: LocationModel, json: [String: Any]){
        let episode = LocationModel(id: 28,
                                    name: "The Ricklantis Mixup",
                                    type: "September 10, 2017",
                                    dimension: "S03E07",
                                    residents: [
                                        "https://rickandmortyapi.com/api/character/1",
                                        "https://rickandmortyapi.com/api/character/2"
                                    ],
                                    created: "2017-11-10T12:56:36.618Z")
        
        let json: [String: Any] = [
            "id": episode.id,
            "name": episode.name,
            "type": episode.type,
            "dimension": episode.dimension,
            "residents": episode.residents,
            "created": episode.created
        ].compactMapValues{ $0 }
        
        return (episode, json)
    }
}
