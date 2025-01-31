//
//  FolderPicker.swift
//  FileHead
//
//  Created by James Edmond on 1/31/25.
//

import SwiftUI

struct FolderPicker: View {
    @Binding var mode: HeadFolder.Mode?
    @ObservedObject var manager: HeadFolderManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack{
            Text("Select Head Folder")
                .font(.headline)
                .padding()
            
            Button("Choose Folder") {
                let panel = NSOpenPanel()
                panel.allowsMultipleSelection = false
                panel.canChooseDirectories = true
                panel.canChooseFiles = false
                if panel.runModal() == .OK, let url = panel.url {
                    if let mode = mode {
                        manager.addHeadFolder(url: url, mode: mode)
                        self.mode = nil
                        dismiss()
                    }
                }
            }
            .padding()
        }
        .frame(width: 300, height: 200)
    }
}

