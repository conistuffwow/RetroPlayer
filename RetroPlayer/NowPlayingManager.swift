//
//  NowPlayingManager.swift
//  RetroPlayer
//
//  Created by Coni on 2025-06-29.
//

import Foundation
import AVFoundation
import iTunesLibrary
import Combine

class NowPlayingManager: ObservableObject {
    // todo
    @Published var currentItem: ITLibMediaItem?
    @Published var isPlaying: Bool = false
    
    private var player: AVAudioPlayer?
    
    func play(item: ITLibMediaItem) {
        guard let url = item.location else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
            
            currentItem = item
            isPlaying = true
        } catch {
            print("Failed to play song \(error)")
        }
    }
    
    func togglePlayPause() {
        guard let player = player else { return }
        
        if player.isPlaying {
            player.pause()
            isPlaying = false
        } else {
            player.play()
            isPlaying = true
        }
    }
}
