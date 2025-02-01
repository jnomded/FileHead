//
//  FollowerListView.swift
//  FileHead
//
//  Created by James Edmond on 1/31/25.
//

import SwiftUI

struct FollowerListView: View {
    @ObservedObject var host: HostFolder
    let hostStore: HostStore
    @State private var hoveredFollower: URL?
    
    var body: some View {
        Group {
            if host.followers.isEmpty {
                ContentUnavailableView(
                    "No Followers",
                    systemImage: "arrowshape.turn.up.right.fill",
                    description: Text("Drag folders here or click the + button to add followers")
                )
            } else {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(host.followers, id: \.self) { follower in
                            HStack {
                                Image(systemName: "folder.fill")
                                    .foregroundStyle(.blue)
                                Text(follower.lastPathComponent)
                                    .lineLimit(1)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.secondary)
                                    .opacity(hoveredFollower == follower ? 1 : 0)
                                    .onTapGesture {
                                        host.removeFollower(follower)
                                        hostStore.saveHosts()
                                    }
                            }
                            .padding(8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(hoveredFollower == follower ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
                            )
                            .onHover { hovering in
                                withAnimation(.easeInOut(duration: 0.1)) {
                                    hoveredFollower = hovering ? follower : nil
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .toolbar {
            Button(action: addFollowerFolder) {
                Label("Add Follower", systemImage: "plus")
            }
        }
        .navigationTitle("Followers of \(host.url.lastPathComponent)")
        .dropDestination(for: URL.self) { items, _ in
            for item in items {
                host.addFollower(item)
                hostStore.saveHosts()
            }
            return true
        }
    }
    
    private func addFollowerFolder() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        
        if panel.runModal() == .OK, let url = panel.url {
            host.addFollower(url)
            hostStore.saveHosts()
            host.syncWithFollowers()
        }
    }
}
