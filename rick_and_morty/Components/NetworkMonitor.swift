//
//  NetworkMonitor.swift
//  rick_and_morty
//
//  Created by Sonic on 24/2/23.
//

import Foundation
import Network

class NetworkMonitor: ObservableObject {
    private let networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "Monitor")
    var isConnected = false
    
    init() {
        networkMonitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
            Task {
                await MainActor.run(body: {
                    self.objectWillChange.send()
                })
            }
        }
        networkMonitor.start(queue: workerQueue)
    }
}
