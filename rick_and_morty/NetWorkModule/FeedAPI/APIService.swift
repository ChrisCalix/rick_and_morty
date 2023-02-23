//
//  APIService.swift
//  rick_and_morty
//
//  Created by Sonic on 23/2/23.
//

import Foundation

final class APIService: HTTPClient {
    
    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            do {
                guard let httpResponse = response as? HTTPURLResponse, let data else {
                    throw RemoteFeedLoader<Any>.Error.connectivity
                }
                
                completion(.success((data, httpResponse)))
            }catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
