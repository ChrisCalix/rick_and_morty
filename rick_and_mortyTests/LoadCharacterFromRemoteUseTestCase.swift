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
            let json = makeItemsJSON([])
            client.complete(withStatusCode: code, data: json, at: index)
            
            waitForExpectations(timeout: 1)
        }
    }
    
    //MARK: Helpers
    
    private func makeSUT(url: URL = URL(string: "https://rickandmortyapi.com/api/character/3")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut, client)
    }
    
    private func makeItemsJSON(_ items: [[String: Any]]) -> Data {
        let json = ["Characters": items]
        return try! JSONSerialization.data(withJSONObject: json)
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
