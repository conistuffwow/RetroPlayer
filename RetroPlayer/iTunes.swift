//
//  iTunes.swift
//  RetroPlayer
//
//  Created by Coni on 2025-06-29.
//

import Foundation
import iTunesLibrary
import Combine

class MusicLibraryManager {
    let library: ITLibrary?
    
    init() {
        self.library = try? ITLibrary(apiVersion: "1.0")
    }
    
    func allSongs() -> [ITLibMediaItem] {
        return library?.allMediaItems.filter { $0.mediaKind == .kindSong} ?? []
    }
}
