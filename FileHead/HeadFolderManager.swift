//
//  HeadFolderManager.swift
//  FileHead
//
//  Created by James Edmond on 1/30/25.
//
import Foundation


@MainActor
class HeadFolderManager: ObservableObject {
    @Published var headFolders: [HeadFolder] = []
    @Published var selectedHeadFolder: HeadFolder?
    //published means notifies observer of changes
    // stateobject owns the instand and observed observes changes
    
    func addHeadFolder(url: URL, mode: HeadFolder.Mode) {
        let newFolder = HeadFolder(url: url, mode: mode, followers: [])
        headFolders.append(newFolder)
        selectedHeadFolder = newFolder
    }
    
    func addFollower (to head: HeadFolder, url: URL) {
        if let index = headFolders.firstIndex(where: { $0.id == head.id}) {
            headFolders[index].followers.append(url)
            
        }
    }
    
    func toggleMode(for folder: HeadFolder) {
        if let index = headFolders.firstIndex(where: { $0.id == folder.id }) {
            headFolders[index].mode = folder.mode == .additive ? .subtractive : .additive
        }
    }
        
}
