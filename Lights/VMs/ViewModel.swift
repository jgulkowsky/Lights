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
    
    func onScreenTap() {
        chooseNewScreenColor()
    }
    
    private func chooseNewScreenColor() {
        screenColor.accept(UIColor.random)
    }
    
    //todo: some ideas
    //todo: add play / pause button (only one and it has two modes) on the bottom of the screen
    //todo: in play mode colors will change automatically with some animation
    //todo: in pause mode color will stay until user taps on screen (or it can ficker a little bit but in the same color)
    //todo: in play mode when user taps on screen he will be shown ui elements like pause button and speedometer (on the right) where he can set up speed of the animation
}
