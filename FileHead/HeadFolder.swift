//
//  HeadFolder.swift
//  FileHead
//
//  Created by James Edmond on 1/30/25.
//
import Foundation


struct HeadFolder: Identifiable, Hashable {
    let id = UUID()
    var url: URL
    var mode: Mode
    var followers: [URL]

    enum Mode {
        case additive, subtractive
    }
}
