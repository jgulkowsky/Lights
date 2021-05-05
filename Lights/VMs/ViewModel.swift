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
    
    var screenColor = BehaviorRelay<UIColor>(value: UIColor.random)
    var mode = BehaviorRelay<Mode>(value: .paused)
    var playPauseButtonIconName = BehaviorRelay<String>(value: TextsAndNames.ViewModel.playButtonIconName)
    var uiVisibility = BehaviorRelay<UIVisibility>(value: .hidden)
    
    var playPauseButtonTappedAtLeastOnce = false
    
    private var hideUITimerDisposeBag = DisposeBag()
    
    init() {
//        print("\(Debug.Log.ViewModel).init")
        showUI(forSeconds: Durations.ViewModel.uiVisibilityInitial)
    }
    
    func onScreenTap() {
//        print("\(Debug.Log.ViewModel).onScreenTap")
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
    
    func onPlayPauseButtonTapWhenItSemiTransparent() {
//        print("\(Debug.Log.ViewModel).onPlayPauseButtonTapWhenItSemiTransparent")
        showUI(forSeconds: Durations.ViewModel.uiVisibility) //todo: this should be dependent on fadeOut / fadeIn level - if fading in then it should not be called or be ignored - this could be accomplished with using FadeableButTappableButtonViewModel - while it has states then maybe here it will be called but then FadeableButTappableButtonViewModel will know what to do with it
        updateMode()
    }
    
    func onPlayPauseButtonTapWhenItIsOpaque() {
//        print("\(Debug.Log.ViewModel).onPlayPauseButtonTapWhenItIsOpaque")
        playPauseButtonTappedAtLeastOnce = true
        prolongShowingUI(forSeconds: Durations.ViewModel.uiVisibility)
        updateMode()
    }
    
    func onColorTransitionComplete() {
//        print("\(Debug.Log.ViewModel).onColorTransitionComplete")
        if mode.value == .playing {
            chooseNewScreenColor()
        }
    }
    
    func onColorTransitionStopped(at color: UIColor?) {
//        print("\(Debug.Log.ViewModel).onColorTransitionStopped")
        guard let color = color else {
            //todo: first of all - it should not happen ever!
            //todo: log error
            fatalError("Color is nil!") //todo: fatalErrors are not the best way out...
        }
        chooseNewScreenColor(color)
    }
    
    private func chooseNewScreenColor(_ color: UIColor? = nil) {
//        print("\(Debug.Log.ViewModel).chooseNewScreenColor")
        let color = color ?? UIColor.random
        screenColor.accept(color)
    }
    
    private func updateMode() {
//        print("\(Debug.Log.ViewModel).updateMode")
        if mode.value == .paused {
            switchToPlayingMode()
        } else {
            switchToPausedMode()
        }
    }
    
    private func switchToPlayingMode() {
//        print("\(Debug.Log.ViewModel).switchToPlayingMode")
        mode.accept(.playing)
        playPauseButtonIconName.accept(TextsAndNames.ViewModel.pauseButtonIconName)
        chooseNewScreenColor()
    }
    
    private func switchToPausedMode() {
//        print("\(Debug.Log.ViewModel).switchToPausedMode")
        mode.accept(.paused)
        playPauseButtonIconName.accept(TextsAndNames.ViewModel.playButtonIconName)
    }
    
    private func showUI(forSeconds seconds: Int) {
//        print("\(Debug.Log.ViewModel).showUI")
        if uiVisibility.value == .hidden {
            uiVisibility.accept(.visible)
            resetHideUITimer(forSeconds: seconds)
        }
    }
    
    private func prolongShowingUI(forSeconds seconds: Int) {
//        print("\(Debug.Log.ViewModel).prolongShowingUI")
        if uiVisibility.value == .visible {
            resetHideUITimer(forSeconds: seconds)
        }
    }
    
    private func resetHideUITimer(forSeconds seconds: Int) {
//        print("\(Debug.Log.ViewModel).resetHideUITimer")
        hideUITimerDisposeBag = DisposeBag()
        Observable.just(())
            .delay(.seconds(seconds), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.uiVisibility.accept(.hidden)
            })
            .disposed(by: hideUITimerDisposeBag)
    }
}
