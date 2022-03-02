//
//  Player.swift
//  ntvos
//
//  Created by Raymond Kennedy on 3/1/22.
//

import Foundation
import SwiftUI
import AVFoundation

class Player: ObservableObject {
    
    var audioPlayer: AVPlayer?

    init() {
        self.audioPlayer = AVPlayer()
    }


    func pauseOrPlay(streamUrl: String) {
        print("Playing: \(streamUrl)")
        
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        
        let url = URL(string: streamUrl)!
        let playerItem = AVPlayerItem(url: url)
        self.audioPlayer?.replaceCurrentItem(with: playerItem)

        self.audioPlayer?.play()

    }
}
