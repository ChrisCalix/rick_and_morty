//
//  LocationViewModel.swift
//  rick_and_morty
//
//  Created by Sonic on 24/2/23.
//

import Foundation

class LocationViewModel: ObservableObject {
    @Published var location : LocationModel?
    @Published var showAlert: Bool = false
    
    func loadSingleLocation(url: URL) {
        let remote = RemoteFeedLoader<LocationModel>(url: url, client: APIService())
        remote.load() { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(feed):
                DispatchQueue.main.async {
                    self.location = feed
                }
            case .failure(_):
                self.showAlert = true
            }
        }
    }
}
