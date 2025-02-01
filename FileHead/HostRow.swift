//
//  HostRow.swift
//  FileHead
//
//  Created by James Edmond on 1/31/25.
//

import SwiftUI

struct HostRow: View {
    @ObservedObject var host: HostFolder
    let hostStore: HostStore
    @State private var isHovered = false
    
    var body: some View {
        HStack {
            Toggle("", isOn: $host.isActive)
                .toggleStyle(.switch)
                .labelsHidden()
                .frame(width: 40)
            
            Image(systemName: "folder.fill")
                .foregroundStyle(host.isActive ? .blue : .secondary)
            
            VStack(alignment: .leading) {
                Text(host.url.lastPathComponent)
                    .font(.headline)
                    .lineLimit(1)
                Text(host.url.path)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Picker("", selection: $host.mode) {
                Text("Add").tag(SyncMode.additive)
                Text("Subtract").tag(SyncMode.subtractive)
            }
            .pickerStyle(.segmented)
            .frame(width: 120)
            .disabled(!host.isActive)
            .onChange(of: host.mode) {
                hostStore.saveHosts()
                host.syncWithFollowers()
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal)
        .background(isHovered ? Color.blue.opacity(0.05) : Color.clear)
        .cornerRadius(8)
        .onHover { hovering in
            isHovered = hovering
        }
        .opacity(host.isActive ? 1.0 : 0.6)
    }
}
