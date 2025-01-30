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
            

        }
    }
    @State private var counter = 0
}

#Preview {
    ContentView()
}
