//
//  FileOperations.swift
//  FileHead
//
//  Created by James Edmond on 1/30/25.
//
import Foundation

func getFilenames(in url: URL) -> Set<String> {
    guard let files = try? FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil) else {
        return[]
    }
    return Set(files.map { $0.deletingPathExtension().lastPathComponent.lowercased()})
}

