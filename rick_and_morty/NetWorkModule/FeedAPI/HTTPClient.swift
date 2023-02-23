//
//  HTTPClient.swift
//  rick_and_morty
//
//  Created by Sonic on 23/2/23.
//

import Foundation

protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void)
}
