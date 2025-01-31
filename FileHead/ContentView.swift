//
//  ContentView.swift
//  FileHead
//
//  Created by James Edmond on 1/28/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var manager = HeadFolderManager()
    @State private var showingFolderPicker = false
    @State private var pickerMode: HeadFolder.Mode?
    
    
    var body: some View {
        HStack(spacing :20) {
            //left panel will include the head folders
            VStack {
                HStack {
                    Text("Head Folders")
                        .font(.headline)
                    Spacer()
                    Button(action: { pickerMode = .additive }) {
                        Image(systemName: "plus")
                    }
                }
                .padding()
                
                List(manager.headFolders, selection: $manager.selectedHeadFolder) { folder in
                    HStack {
                        Text(folder.url.lastPathComponent)
                        Spacer()
                        Button(action: {
                            manager.toggleMode(for: folder)
                        }) {
                            Text(folder.mode == .additive ? "Additive" : "Subtractive")
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(folder.mode == .additive ? Color.blue : Color.red)
                                .cornerRadius(5)
                            
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                    }
                    .tag(folder)
                }
                .listStyle(SidebarListStyle())
            }
            .frame(width: 300)
            
            //right panel will show head folders followers
            VStack {
                if let selected = manager.selectedHeadFolder {
                    HStack {
                        Text("Follwers for \(selected.url.lastPathComponent)")
                            .font(.headline)
                        Spacer()
                        Button("Add Follower") {
                            let panel = NSOpenPanel()
                            panel.allowsMultipleSelection = true
                            panel.canChooseDirectories = true
                            panel.canChooseFiles = false
                            if panel.runModal() == .OK {
                                for url in panel.urls {
                                    manager.addFollower(to: selected, url: url)
                                }
                            }
                        }
                    }
                    .padding()
                    
                    List(selected.followers, id: \.self) { follower in
                        Text(follower.lastPathComponent)
                    }
                    
                    Button("Execute") {
                        executeOperations(for: selected)
                    }
                    .padding()
                } else {
                    Text("Select a head folder to view followers")
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .sheet(isPresented: $showingFolderPicker) {
            FolderPicker(mode: $pickerMode, manager: manager)
        }
        .onChange(of: pickerMode) {
            if pickerMode != nil {
                showingFolderPicker = true
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
