//
//  HTTPClient.swift
//  rick_and_morty
//
//  Created by Sonic on 23/2/23.
//

import Foundation

enum HTTPError : Error {
    case notHttpURLResponse
}

protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void)
}
