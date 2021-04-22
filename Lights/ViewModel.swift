//
//  ViewModel.swift
//  Lights
//
//  Created by Jan Gulkowski on 23/04/2021.
//

import UIKit
import RxCocoa

class ViewModel {
    
    var screenColor = BehaviorRelay<UIColor>(value: .systemPurple)
    
    func onScreenTap() {
        print("onScreenTap")
        chooseNewScreenColor()
    }
    
    private func chooseNewScreenColor() {
        screenColor.accept(.systemPink)
    }
}
