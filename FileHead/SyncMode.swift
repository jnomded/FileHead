//
//  SyncMode.swift
//  FileHead
//
//  Created by James Edmond on 1/31/25.
//

import Foundation

enum SyncMode: Codable {
    case additive, subtractive
    
    var description: String {
        switch self {
        case .additive: return "Additive"
        case .subtractive: return "Subtractive"
        }
    }
}
