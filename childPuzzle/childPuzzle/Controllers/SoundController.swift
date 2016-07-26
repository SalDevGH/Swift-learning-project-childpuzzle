//
//  MusicController.swift
//  childPuzzle
//
//  Copyright © 2016 gsaliga. All rights reserved.
//

import Foundation
import AVFoundation

// Music and Sound Effect controller
class SoundController {
    private let model = SoundModel()
    private var currentlyPlayedMusicTrack = ""
	
    
    // starts playback of a music infinitely
    // if fadeInDuration is set to 0, the track will be starting immediately
    internal func playMusic(alias: String, fadeInDuration: NSTimeInterval, loopForever: Bool) {
        self.model.playMusic(alias, fadeInDuration: fadeInDuration, loopForever: loopForever)
        self.currentlyPlayedMusicTrack = alias
    }

    // stops playing a started playback
    internal func stopMusic() {
        if self.currentlyPlayedMusicTrack != "" {
            self.model.stopMusic(0, fadeOutCallback: {
                self.musicDidStop()
            })
        }
    }

    // starts the fade-out effect (lowering volume) until it reaches ZERO, after that the music will be stopped
    internal func startFadeOutMusic(duration: NSTimeInterval) {
        if self.currentlyPlayedMusicTrack != "" {
            self.model.stopMusic(duration, fadeOutCallback: {
                self.musicDidStop()
            })
        }
    }

    // prepares an effect for playing
    internal func loadEffect(alias: String) -> Bool {
        return self.model.loadEffect(alias)
    }

    // plays a sound effect once
    internal func playEffect(alias: String) {
        self.model.playEffect(alias)
    }

    // stops playing any effects currently played
    internal func stopAllEffects() {
        self.model.stopAllEffects()
    }

    // called every time when a music track is stopped playing
    private func musicDidStop() {
        self.currentlyPlayedMusicTrack = ""
    }

}
