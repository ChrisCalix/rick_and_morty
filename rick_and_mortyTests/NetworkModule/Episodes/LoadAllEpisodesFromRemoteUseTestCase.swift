//
//  LoadAllEpisodesFromRemoteUseTestCase.swift
//  rick_and_mortyTests
//
//  Created by Sonic on 23/2/23.
//

import XCTest
@testable import rick_and_morty

class LoadAllEpisodesFromRemoteUseTestCase: NetworkTestCase<AllEpisodesModel> {
    
    func test_allEpisodes_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()

        XCTAssertTrue(client.requestedURLs.isEmpty)
    }

    func test_allEpisodes_loadTwiceRequestDataFromURLTwice() {
        let url = URL(string: "https://rickandmortyapi.com/api/character/3")!
        let (sut, client) = makeSUT(url: url)

        sut.load { _ in }
        sut.load { _ in }

        XCTAssertEqual(client.requestedURLs, [url, url])
    }

    func test_allEpisodes_loadDeliversConnectivityErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(.connectivity), when: {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        })
    }

    func test_allEpisodes_loadDeliversInvalidDataErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()

        let samples = [199, 201, 300, 400, 500]

        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: .failure(.invalidData), when: {
                let json = makecharacterJSON()
                client.complete(withStatusCode: code, data: json, at: index)
            })
        }
    }

    func test_allEpisodes_loadDeliversInvalidDataErrorOn200HTTPResponseWithinvalidJSON() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: .failure(.invalidData), when: {
            let invalidJSON = Data("invalid JSON".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }
    
    func test_allEpisodes_loadDeliversSuccessWithNoItemsOn200HTTPResponseWithJSONItems() {
        let (sut, client) = makeSUT()
        
        let episodes = makeAllEpisodes()
        
        expect(sut, toCompleteWith: .success(episodes.model), when: {
            let json = makecharacterJSON(episodes.json)
            client.complete(withStatusCode: 200, data: json)
        })
    }
    
    // MARK: Helpers
    override func makeSUT(url: URL = URL(string: "https://rickandmortyapi.com/api/character/3")!, file: StaticString = #filePath, line: UInt = #line) -> (sut: RemoteFeedLoader<AllEpisodesModel>, client: HTTPClientSpy) {
        super.makeSUT(url: url, file: file, line: line)
    }
    
    func makeAllEpisodes() -> (model: AllEpisodesModel, json: [String: Any]){
        let episode = EpisodeModel(id: 28,
                     name: "The Ricklantis Mixup",
                     air_date: "September 10, 2017",
                     episode: "S03E07",
                     characters: [
                        "https://rickandmortyapi.com/api/character/1",
                        "https://rickandmortyapi.com/api/character/2"
                     ],
                     url: "https://rickandmortyapi.com/api/episode/28",
                     created: "2017-11-10T12:56:36.618Z")
        
        let allEpisodes = AllEpisodesModel(results: [episode, episode])
        
        let episodeJson : [String: Any] = [
            "id": episode.id,
            "name": episode.name,
            "air_date": episode.air_date,
            "episode": episode.episode,
            "characters": episode.characters,
            "url": episode.url,
            "created": episode.created
        ]
        
        let json: [String: Any] = [
            "results": [episodeJson, episodeJson]
        ].compactMapValues{ $0 }
        
        return (allEpisodes, json)
    }
}
