//
//  FileModes.swift
//  FileHead
//
//  Created by James Edmond on 1/30/25.
//
import SwiftUI

private func toggleMode(for folder: HeadFolder) {
    if let index = manager.headFolders.firstIndex(where: {$0.id == folder.id}) {
        manager.headFolders[index].mode = folder.mode == .additive ? .subtractive : .additive
        
    }
  }
