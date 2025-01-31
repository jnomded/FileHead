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

func deleteFiles(names:Set<String>, in directory: URL) {
    guard let files = try? FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil) else {
        return
    }
    
    for file in files{
        let name = file.deletingPathExtension().lastPathComponent.lowercased()
        if names.contains(name){
            try? FileManager.default.removeItem(at: file)
        }
    }
}

func copyMissingFiles(from source: URL, to destination: URL, existingFilenames: Set<String>) {
    
    guard let files = try? FileManager.default.contentsOfDirectory(at: source, includingPropertiesForKeys: nil) else {
        return
    }
    for file in files{
        let name = file.deletingPathExtension().lastPathComponent.lowercased()
        if !existingFilenames.contains(name){
            let destURL = destination.appendingPathComponent(file.lastPathComponent)
            try? FileManager.default.copyItem(at: file, to: destURL)
        }
    }
}

func executeOperations(for head: HeadFolder) {
    let headFiles = getFilenames(in: head.url)
    
    for follower in head.followers {
        if head.mode == .subtractive {
            let followerFiles = getFilenames(in: follower)
            let toDelete = followerFiles.subtracting(headFiles)
            deleteFiles(names: toDelete, in: follower)
        } else {
            copyMissingFiles(from: head.url, to: follower, existingFilenames: getFilenames(in: follower))
        }
    }
}
