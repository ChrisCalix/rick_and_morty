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
        let client = HTTPClientSpy()
        let _ = RemoteFeedLoader(url: URL(string: "https://a-url.com")!, client: client)
        XCTAssertTrue(client.requestedURLs.isEmpty)
        
    }
    
    func test_load_requestDataFromURL() {
        let url = URL(string: "https://rickandmortyapi.com/api/character/3")
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url!, client: client)
        
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    //MARK: Helpers
    private class HTTPClientSpy: HTTPClient {
        private var messages = [(url: URL, completion: (HTTPClient.Result) -> Void)]()
        
        var requestedURLs: [URL] {
            return messages.map {$0.url}
        }
        
        func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
            messages.append((url, completion))
        }
        
        
    }
}
