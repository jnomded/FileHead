//
//  ContentView.swift
//  FileHead
//
//  Created by James Edmond on 1/28/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
       Text("Hello, FileHead")
        .padding()
        
        HStack {
            
            Text("Left Panel")
                .padding()
            Divider()
            Text("Right Panel")
                .padding()
            
            
        }
    }
    @State private var counter = 0
}

#Preview {
    ContentView()
}
