//
//  ContentView.swift
//  FileHead
//
//  Created by James Edmond on 1/28/25.
//

import SwiftUI


struct ContentView: View {
    @StateObject public var manager = HeadFolderManager()
    @State private var showingFolderPicker = false
    @State private var pickerMode: HeadFolder.Mode?
    
    
    var body: some View {
        
        VStack {
            HStack{
                Text("Head Folders")
                    .font(.headline)
                Spacer()
                Button(action: {pickerMode = .additive}) {
                    Image(systemName: "plus")
                }
            }
            .padding()
            
            List(manager.headFolders, selection: $manager.selectedHeadFolder) { folder in
                HStack{
                    Text(folder.url.lastPathComponent)
                    Spacer()
                    Button(action: {
                        toggleMode(for: folder)
                            
                    }) {
                        Text(folder.mode == .additive ? "Additive" : "Subtractive")
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(folder.mode == .additive ? Color.green : Color.red)
                            .cornerRadius(5)
                        
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                }
                .tag(folder)
                
            }
            .listStyle(SidebarListStyle())
        }
        .frame(width:300)
        
        // now for the right panel
    }
}

    
    #Preview {
        ContentView()
    }
