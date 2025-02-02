//
//  ContentView.swift
//  FileHead
//
//  Created by James Edmond on 1/28/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var hostStore = HostStore()
    @State private var selectedHost: HostFolder?
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedHost) {
                ForEach(hostStore.hosts) { host in
                    HostRow(host: host, hostStore: hostStore)
                        .tag(host)
                        .contextMenu {
                            Button("Remove Host") {
                                hostStore.removeHost(host)
                                if selectedHost == host {
                                    selectedHost = nil
                                }
                            }
                        }
                }
            }
            .toolbar {
                Button(action: addHostFolder) {
                    Label("Add Host Folder", systemImage: "plus")
                }
            }
            .navigationTitle("Host Folders")
        } detail: {
            if let selectedHost = selectedHost {
                FollowerListView(host: selectedHost, hostStore: hostStore)
            } else {
                ContentUnavailableView(
                    "Select a Host Folder",
                    systemImage: "folder.badge.gear",
                    description: Text("Click the + button to add a new host folder")
                )
            }
        }
        .onChange(of: hostStore.hosts) { _, newHosts in
            if let selectedHost = selectedHost, !newHosts.contains(selectedHost) {
                self.selectedHost = nil
            }
        }
    }
    
    private func addHostFolder() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        
        if panel.runModal() == .OK, let url = panel.url {
            let newHost = HostFolder(url: url)
            hostStore.addHost(newHost)
        }
    }
}

#Preview {
    ContentView()
}

