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
    var mode = BehaviorRelay<Mode>(value: .paused) //todo: do we really need it? in this moment nothing subsribes to it
    var playPauseButtonIconName = BehaviorRelay<String>(value: "play")
    var uiVisibility = BehaviorRelay<UIVisibility>(value: .hidden)
    
    private var hideUITimerDisposeBag = DisposeBag()
    
    init() {
        showUI(forSeconds: Durations.ViewModel.uiVisibilityInitial)
    }
    
    func onScreenTap() {
        if (uiVisibility.value == .hidden) {
            showUI(forSeconds: Durations.ViewModel.uiVisibility)
        } else {
            prolongShowingUI(forSeconds: Durations.ViewModel.uiVisibility)
            chooseNewScreenColor()
        }
    }
    
    func onPlayPauseButtonTap() {
        if mode.value == .paused {
            switchToPlayingMode()
        } else {
            switchToPausedMode()
        }
    }
    
    private func chooseNewScreenColor() {
        screenColor.accept(UIColor.random)
    }
    
    private func switchToPlayingMode() {
        //print("switchToPlayingMode")
        mode.accept(.playing)
        playPauseButtonIconName.accept("pause")
        //todo: start color transition
    }
    
    private func switchToPausedMode() {
        //print("switchToPausedMode")
        mode.accept(.paused)
        playPauseButtonIconName.accept("play")
        //todo: stop color transition
    }
    
    private func showUI(forSeconds seconds: Int) {
        if uiVisibility.value == .hidden {
            print("make ui visible")
            uiVisibility.accept(.visible)
            resetHideUITimer(forSeconds: seconds)
        }
    }
    
    private func prolongShowingUI(forSeconds seconds: Int) {
        if uiVisibility.value == .visible {
            print("prolong showing ui")
            resetHideUITimer(forSeconds: seconds)
        }
    }
    
    private func resetHideUITimer(forSeconds seconds: Int) {
        hideUITimerDisposeBag = DisposeBag()
        Observable.just(())
            .delay(.seconds(seconds), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.uiVisibility.accept(.hidden)
                print("make ui hidden")
            })
            .disposed(by: hideUITimerDisposeBag)
    }
    
    //todo: prolong viisbility also on playPauseButtonTap - but first do some animations - as it can bahave differently if you did it vice versa
}
