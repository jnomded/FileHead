//
//  HeadFolder.swift
//  FileHead
//
//  Created by James Edmond on 1/30/25.
//
import SwiftUI

struct HeadFolder: Identifiable {
    let id = UUID()
    var url: URL
    var mode: Mode
    var followers: [URL]

    enum Mode {
        case additive, subtractive
    }
}
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
        
}
