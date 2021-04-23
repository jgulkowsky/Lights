//
//  ViewModel.swift
//  Lights
//
//  Created by Jan Gulkowski on 23/04/2021.
//

import UIKit
import RxCocoa

class ViewModel {
    
    var screenColor = BehaviorRelay<UIColor>(value: UIColor.random)
    var mode = BehaviorRelay<Mode>(value: .paused) //todo: do we really need it? in this moment nothing subsribes to it
    var playPauseButtonIconName = BehaviorRelay<String>(value: "play")
    
    func onScreenTap() {
        chooseNewScreenColor()
    }
    
    func onPlayPauseButtonTap() {
        if mode.value == .paused {
            switchToPlayingMode()
        } else {
            switchToPausedMode()
        }
        clearUI(afterSeconds: 2)
    }
    
    private func chooseNewScreenColor() {
        screenColor.accept(UIColor.random)
    }
    
    private func switchToPlayingMode() {
        print("switchToPlayingMode")
        mode.accept(.playing)
        playPauseButtonIconName.accept("pause")
        //todo: start color transition
    }
    
    private func switchToPausedMode() {
        print("switchToPausedMode")
        mode.accept(.paused)
        playPauseButtonIconName.accept("play")
        //todo: stop color transition
    }
    
    private func clearUI(afterSeconds seconds: Int) {
        //todo: ui visible
        //todo: after time ui invisible -> we need to store this state too
    }
}
