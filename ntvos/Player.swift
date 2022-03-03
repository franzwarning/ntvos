//
//  Player.swift
//  ntvos
//
//  Created by Raymond Kennedy on 3/1/22.
//

import Foundation
import SwiftUI
import AVFoundation


enum CustomPlayerStatus {
    case None
    case Loading
    case Playing
    case Paused
}

class Player: AVPlayer, ObservableObject  {
    
    @Published var customerPlayerStatus: CustomPlayerStatus = .None
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        if keyPath == "timeControlStatus" {
            if self.timeControlStatus == .playing {
                self.customerPlayerStatus = .Playing
            } else if timeControlStatus == .paused {
                self.customerPlayerStatus = .Paused
            } 
        }
    }
    
    
    override init() {
        super.init()
        self.addObserver(self, forKeyPath: "status", options: [.new], context: nil)
        self.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
        self.addObserver(self, forKeyPath: "rate", options: [.old, .new], context: nil)
    }
    
    func toggle() {
        if (self.customerPlayerStatus == .Playing) {
            self.pause()
        } else if (self.customerPlayerStatus == .Paused) {
            self.play()
        }
    }
    
    func stop() {
        self.pause()
        self.rate = 0
        self.customerPlayerStatus = .None
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    func startPlay(streamUrl: String) {
        print("Playing: \(streamUrl)")
        
        DispatchQueue.main.async {
            self.customerPlayerStatus = .Loading
            
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        
        let url = URL(string: streamUrl)!
        let playerItem = AVPlayerItem(url: url)
        self.replaceCurrentItem(with: playerItem)
        self.play()
        UIApplication.shared.isIdleTimerDisabled = true
    }
}
