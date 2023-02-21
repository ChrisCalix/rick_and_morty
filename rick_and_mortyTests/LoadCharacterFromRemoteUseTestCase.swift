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
    
//    func test_loadTwice_requestDataFromURLTwice() {
//        let url = URL(string: "https://rickandmortyapi.com/api/character/3")
//        let client = HTTPClientSpy()
//        let sut = RemoteFeedLoader(url: url!, client: client)
//        
//        sut.load { _ in }
//        sut.load { _ in }
//        
//        XCTAssertEqual(client.requestedURLs, [url, url])
//    }
    
    func test_deliversConnectivityErrorOnClientError() {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: URL(string: "https://rickandmortyapi.com/api/character/3")!, client: client)
        
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
    
    //MARK: Helpers
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
        
    }
}
