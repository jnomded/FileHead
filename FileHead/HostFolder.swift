//
//  HostFolder.swift
//  FileHead
//
//  Created by James Edmond on 1/31/25.
//

import Foundation

class HostFolder: Identifiable, Codable, ObservableObject, Hashable {
    static func == (lhs: HostFolder, rhs: HostFolder) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id = UUID()
    let url: URL
    @Published var mode: SyncMode = .additive
    @Published var followers: [URL] = []
    @Published var isActive = true
    private var lastKnownContents: [URL]?
    
    enum CodingKeys: CodingKey {
        case id, url, mode, followers
    }
    
    init(url: URL) {
        self.url = url
    }
    
    func addFollower(_ url: URL) {
        followers.append(url)
        syncWithFollowers()
    }
    
    func removeFollower(_ url: URL) {
        followers.removeAll { $0 == url }
        syncWithFollowers()
    }
    
    func syncWithFollowers() {
        guard isActive else { return }
        
        DispatchQueue.global(qos: .background).async {
            switch self.mode {
            case .additive:
                self.copyToFollowers()
            case .subtractive:
                self.cleanFollowers()
            }
            self.lastKnownContents = try? FileManager.default.contentsOfDirectory(at: self.url, includingPropertiesForKeys: nil)
        }
    }
    
    func checkForChangesAndSync() {
        guard isActive else { return }
        
        let currentContents = (try? FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)) ?? []
        let currentFilenames = currentContents.map { $0.lastPathComponent }
        let lastFilenames = lastKnownContents?.map { $0.lastPathComponent } ?? []
        
        guard currentFilenames != lastFilenames else { return }
        
        syncWithFollowers()
        lastKnownContents = currentContents
    }
    
    private func copyToFollowers() {
        guard let contents = try? FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil) else { return }
        
        for follower in followers {
            for file in contents {
                let destination = follower.appendingPathComponent(file.lastPathComponent)
                if !FileManager.default.fileExists(atPath: destination.path) {
                    try? FileManager.default.copyItem(at: file, to: destination)
                }
            }
        }
    }
    
    private func cleanFollowers() {
        guard let hostContents = try? FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil) else { return }
        let hostFilenames = hostContents.map { $0.lastPathComponent }
        
        for follower in followers {
            guard let followerContents = try? FileManager.default.contentsOfDirectory(at: follower, includingPropertiesForKeys: nil) else { continue }
            
            for file in followerContents {
                if !hostFilenames.contains(file.lastPathComponent) {
                    try? FileManager.default.removeItem(at: file)
                }
            }
        }
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        url = try container.decode(URL.self, forKey: .url)
        mode = try container.decode(SyncMode.self, forKey: .mode)
        followers = try container.decode([URL].self, forKey: .followers)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(url, forKey: .url)
        try container.encode(mode, forKey: .mode)
        try container.encode(followers, forKey: .followers)
    }
}
