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
    
    //todo: IMPORTANT when playPauseButton is fading out it doesn't react on touches - I wrote about it earlier but didn't notice then that this can be bothering and that it seems as our ui is broken a little bit - I think we sould try to do it in such way that play/pause functionality is available as long as we can see the button (even really really poorly as it's almost zero opacity) - if you do so also check with onScreenTap - as this possibly can cause such situation that when you tap on button you will change mode but in same moment if you tap on screen you will just make button visible again (and not change bg color) - however this is maybe okay? Think about it anyway
    //todo: IMPORTANT but for sure we need to change this fading out inactivity - this is really annoying especially when button is quite opaque still (let's say it has 90% opacity and seems like normal active button - then it looks as it ust doesn't respond to our action and that ui is broken)
    //todo: probably you will have to use option userInteractionEnabled = true - and it probably needs to be set up in uiviewpropertyanimator constructor
    //todo: it's probably not so easy - as there's a problem when we do animation with alpha to 0 - then button is unresponsive event with using userInteractionEnabled (source: https://stackoverflow.com/questions/13499817/does-uibutton-become-disabled-when-its-alpha-is-set-to-0-0)
    //todo: possible solution: add viewBehind then button with size of this button, view is transparent (or if impossible because of alpha 0 - however for tapGesture maybe it's ok? check out - then it can always be in color of the bg) call it sth like fadingOutButtonHelperView and when it's tapped then make button visible and change it to opposite mode at once
    //todo: we could also use just one view instead of button and helper - just use view with tapGesture instea of button with tapping auto implemented - of course if tap gesture can work when transparent - and then we will change mode to inactive only if really alpha is zero
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
