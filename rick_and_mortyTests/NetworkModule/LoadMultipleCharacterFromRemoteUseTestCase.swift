//
//  LoadMultipleCharacterFromRemoteUseTestCase.swift
//  rick_and_mortyTests
//
//  Created by Sonic on 23/2/23.
//

import XCTest
@testable import rick_and_morty

class LoadMultipleCharacterFromRemoteUseTestCase: XCTestCase {
    
    func test_multipleCharacter_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()

        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    //MARK: Helpers
    private func makeSUT(url: URL = URL(string: "https://rickandmortyapi.com/api/character/1,2,3")!, file: StaticString = #filePath, line: UInt = #line) -> (sut: RemoteFeedLoader<[FeedCharacter]>, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader<[FeedCharacter]>(url: url, client: client)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        return (sut, client)
    }
}
