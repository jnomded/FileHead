//
//  HostStore.swift
//  FileHead
//
//  Created by James Edmond on 1/31/25.
//

import SwiftUI
import Combine

class HostStore: ObservableObject {
    @Published var hosts: [HostFolder] = []
    private let userDefaultsKey = "hostFolders"
    private var timer: AnyCancellable?
    
    init() {
        loadHosts()
        startMonitoring()
    }
    
    func addHost(_ host: HostFolder) {
        hosts.append(host)
        saveHosts()
        host.syncWithFollowers()
    }
    
    func removeHost(_ host: HostFolder) {
        hosts.removeAll { $0.id == host.id }
        saveHosts()
    }
    
    private func loadHosts() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey),
              let decoded = try? JSONDecoder().decode([HostFolder].self, from: data) else { return }
        hosts = decoded
    }
    
    func saveHosts() {
        if let encoded = try? JSONEncoder().encode(hosts) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    private func startMonitoring() {
        timer = Timer.publish(every: 5, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.checkForUpdates()
            }
    }
    
    private func checkForUpdates() {
        DispatchQueue.global(qos: .background).async {
            for host in self.hosts {
                host.checkForChangesAndSync()
            }
        }
    }
    
    deinit {
        timer?.cancel()
    }
}
