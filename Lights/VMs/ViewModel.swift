//
//  ViewModel.swift
//  Lights
//
//  Created by Jan Gulkowski on 23/04/2021.
//

import UIKit
import RxCocoa
import RxSwift

class ViewModel {
    //todo: checkout if all of these needs to be BahaviourRelays - maybe some of them could be just normal variables - if we don't subscribe to them then there's no point for making them relays
    var screenColor = BehaviorRelay<UIColor>(value: UIColor.random)
    var mode = BehaviorRelay<Mode>(value: .paused) //todo: do we really need it? in this moment nothing subsribes to it
    var playPauseButtonIconName = BehaviorRelay<String>(value: TextsAndNames.ViewModel.playButtonIconName)
    var uiVisibility = BehaviorRelay<UIVisibility>(value: .hidden)
    
    var playPauseButtonTappedAtLeastOnce = false
    
    private var hideUITimerDisposeBag = DisposeBag()
    
    init() {
        showUI(forSeconds: Durations.ViewModel.uiVisibilityInitial)
    }
    
    func onScreenTap() {
        if uiVisibility.value == .hidden {
            showUI(forSeconds: Durations.ViewModel.uiVisibility)
        } else {
            prolongShowingUI(forSeconds: Durations.ViewModel.uiVisibility)
            if mode.value == .paused {
                chooseNewScreenColor()
                //todo: okey logically it's okay and fixes some problems - but it feels strange when you tap on screen and nothing happend
                //todo: so we need to add some indicator - maybe local animation / distortion / like a wave is spreading from the point of touch to the margins of the screen - this will be hard though - but so fancy!! :)
            }
        }
    }
    
    func onPlayPauseButtonTap() {
        print("onPlayPauseButtonTap")
        playPauseButtonTappedAtLeastOnce = true
        prolongShowingUI(forSeconds: Durations.ViewModel.uiVisibility)
        if mode.value == .paused {
            switchToPlayingMode()
        } else {
            switchToPausedMode()
        }
    }
    
    func onColorTransitionComplete() {
        print("onColorTransitionComplete")
        if mode.value == .playing {
            chooseNewScreenColor()
        }
    }
    
    func onColorTransitionStopped(at color: UIColor?) {
        print("onColorTransitionStopped")
        guard let color = color else {
            //todo: first of all - it should not happen ever!
            //todo: log error
            fatalError("Color is nil!") //todo: fatalErrors are not the best way out...
        }
        chooseNewScreenColor(color)
    }
    
    private func chooseNewScreenColor(_ color: UIColor? = nil) {
        print("chooseNewScreenColor")
        let color = color ?? UIColor.random
        screenColor.accept(color)
    }
    
    private func switchToPlayingMode() {
        print("switchToPlayingMode")
        mode.accept(.playing)
        playPauseButtonIconName.accept(TextsAndNames.ViewModel.pauseButtonIconName)
        chooseNewScreenColor()
    }
    
    private func switchToPausedMode() {
        print("switchToPausedMode")
        mode.accept(.paused)
        playPauseButtonIconName.accept(TextsAndNames.ViewModel.playButtonIconName)
    }
    
    private func showUI(forSeconds seconds: Int) {
        if uiVisibility.value == .hidden {
            //print("make ui visible")
            uiVisibility.accept(.visible)
            resetHideUITimer(forSeconds: seconds)
        }
    }
    
    private func prolongShowingUI(forSeconds seconds: Int) {
        if uiVisibility.value == .visible {
            //print("prolong showing ui")
            resetHideUITimer(forSeconds: seconds)
        }
    }
    
    private func resetHideUITimer(forSeconds seconds: Int) {
        hideUITimerDisposeBag = DisposeBag()
        Observable.just(())
            .delay(.seconds(seconds), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.uiVisibility.accept(.hidden)
                //print("make ui hidden")
            })
            .disposed(by: hideUITimerDisposeBag)
    }
}
