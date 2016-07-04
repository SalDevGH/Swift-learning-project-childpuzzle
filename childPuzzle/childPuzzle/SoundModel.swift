//
//  SoundModel.swift
//  childPuzzle
//
//  Copyright © 2016 gsaliga. All rights reserved.
//

import AVFoundation

// Implements a basic sound player. It uses AVAudioPlayer as sound engine.
// It supports for an infinite playback of a music, and playing sound effect for one time
class SoundModel {
    private var musicEngine    = AVAudioPlayer?()
    private var effectElements = [soundEffectElement()]

    private static let maxVolume:Float      = 1.0
    private static let minVolume:Float      = 0.0
    private static let fadeVolumeStep:Float = 0.1

    // Following structure is used internally for storing engines for effects
    internal struct soundEffectElement {
        var name:String  = ""
        var effectEngine = AVAudioPlayer?()
    }


    // starts playing a music infinitely
    internal func playMusic(alias: String, fadeInDuration: NSTimeInterval, loopForever: Bool) -> Bool {
        if self.musicEngine != nil && self.musicEngine!.playing {
            self.musicEngine!.stop()
        }


		let soundFilePath = NSBundle.mainBundle().pathForResource(alias, ofType: Defines.AUDIO_CFG.fileFormat)
		let soundFileURL  = NSURL(fileURLWithPath: soundFilePath!)
		let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT

        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            do {
                try self.musicEngine = AVAudioPlayer(contentsOfURL: soundFileURL)
                self.musicEngine!.numberOfLoops = (loopForever ? -1 : 0)

                if fadeInDuration == 0 {
                    self.musicEngine!.volume = SoundModel.maxVolume
                    self.musicEngine!.play()
                } else {
                    self.musicEngine!.volume = SoundModel.minVolume
                    self.musicEngine!.play()

                    let countSteps = Double((SoundModel.maxVolume - SoundModel.minVolume) / SoundModel.fadeVolumeStep)
                    self.fadeInMusic(fadeInDuration / countSteps)
                }
            } catch {
				print("Error happened while trying to play music file with alias: \(alias)")
            }
        }

        return true
    }

    // stops the actually played music if there were any
    internal func stopMusic(fadeOutDuration: NSTimeInterval, fadeOutCallback: () -> Void) {
        if self.musicEngine!.playing {

            if fadeOutDuration == 0 {
                self.stopMusicImmediately()
            } else {
                self.musicEngine!.volume = SoundModel.maxVolume
                let countSteps = Double((SoundModel.maxVolume - SoundModel.minVolume) / SoundModel.fadeVolumeStep)

                self.fadeOutAndStopMusic(fadeOutDuration / countSteps, callback: fadeOutCallback)
            }

        }
    }

    // fades in an already muted and started track until it reaches the maximum volume
    // note that it and invokes itself after 'step' duration
    internal func fadeInMusic(step: NSTimeInterval) {
        if self.musicEngine!.playing {
            if self.musicEngine!.volume < (SoundModel.maxVolume - SoundModel.fadeVolumeStep) {

                self.musicEngine!.volume += SoundModel.fadeVolumeStep
                let triggerTime = (Int64(NSTimeInterval(NSEC_PER_SEC) * step))

                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
                    self.fadeInMusic(step)
                })

            } else {
                self.musicEngine!.volume = SoundModel.maxVolume
            }
        }
    }

    // fades out one step, and invokes itself after 'step' duration
    // finally it stops fading
    internal func fadeOutAndStopMusic(step: NSTimeInterval, callback: () -> Void) {
        if self.musicEngine!.playing {
            if self.musicEngine!.volume > (SoundModel.minVolume + SoundModel.fadeVolumeStep) {

                self.musicEngine!.volume -= SoundModel.fadeVolumeStep
                let triggerTime = (Int64(NSTimeInterval(NSEC_PER_SEC) * step))

                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
                    self.fadeOutAndStopMusic(step, callback: callback)
                })

            } else {
                self.musicEngine!.volume = SoundModel.minVolume
                self.stopMusicImmediately()
            }
        }
    }

    // stops the music no matter what
    internal func stopMusicImmediately() {
        self.musicEngine!.stop()
    }

    // loads an effect which could be played later
	// returns false when the loading was not success or when the effect was already loaded
    internal func loadEffect(alias: String) -> Bool {
		// loading only when it is not loaded already
		if self.searchElementByName(alias)?.effectEngine! != nil {
			return false
		}

		// now loading
        let soundFilePath = NSBundle.mainBundle().pathForResource(alias, ofType: Defines.AUDIO_CFG.fileFormat)
        let soundFileURL  = NSURL(fileURLWithPath: soundFilePath!)

        do {
            let effectEngine = try AVAudioPlayer(contentsOfURL: soundFileURL)
            effectEngine.numberOfLoops = 0

            self.effectElements.append(soundEffectElement(name: alias, effectEngine: effectEngine))
        } catch {
            return false
        }

        return true
    }

    // plays a sound effect which has already been loaded
    internal func playEffect(alias: String) {
        let effectEngine = self.searchElementByName(alias)?.effectEngine!

        effectEngine?.currentTime = 0
        effectEngine?.play()
    }

    // stops playing all effects
    internal func stopAllEffects() {
        for (_, element) in self.effectElements.enumerate() {
            element.effectEngine?.stop()
        }
    }

	// returns with an already registered element by name
	// returns nil if not found
	internal func searchElementByName(name: String) -> soundEffectElement? {
		for (_, element) in self.effectElements.enumerate() {
			if element.name == name {
				return element
			}
		}

		return nil
	}
}
