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
    func makeSUT(url: URL = URL(string: "")!, file: StaticString = #filePath, line: UInt = #line) -> (sut: RemoteFeedLoader<T>, client: HTTPClientSpy) {
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
    
    func makecharacterJSON(_ character: [String: Any] = ["": ""]) -> Data {
        return try! JSONSerialization.data(withJSONObject: character)
    }
}
