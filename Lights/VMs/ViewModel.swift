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
    
    //todo: same ideas (almost) but more precise:
    //todo: tapping on PLAY button switches mode to playing
    //todo: tapping on PAUSE button switches mode to paused
    //todo: when in paused mode the color is constant until user changes it manualy
    //todo: when in plauing mode the color changes with transition
    //todo: in playing mode user can change speed of changes with speedometer on the right hand side
    //todo: normally ui is invisible to activate it user needs to tap (it doesn't change color in such situation)
    //todo: in playing mode user will see PAUSE button to switch mode and speedometer
    //todo: in paused mode user will see only PLAY button to switch mode
    //todo: when ui is visible and user taps on screen the color is changed to some other random one (it's true for both modes)
}
