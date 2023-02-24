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
            if let error  {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, let data else {
                completion(.failure(HTTPError.dataInvalid))
                return
            }

            completion(.success((data, httpResponse)))
        }

        task.resume()
    }
    
    enum HTTPError : Error {
        case dataInvalid
    }
}
