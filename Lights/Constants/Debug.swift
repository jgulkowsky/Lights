//
//  Debug.swift
//  Lights
//
//  Created by Jan Gulkowski on 06/05/2021.
//

import Foundation

struct Debug {
    
    struct Log {
        static let viewController = "ViewController"
        static let viewModel = "ViewModel"
        static let fadeableButTappableButton = "FadeableButTappableButton"
    }
    
    struct Error {
        struct ViewController {
            static let requiredInit = "init(coder:) has not been implemented"
            static let playPauseButtonIconNameElementNil = "Nil value found in playPauseButtonIconName.element"
            static let selfIsNil = "self is nil"
        }
        
        struct ViewModel {
            static let colorIsNil = "Color is nil"
        }
        
        struct FadeableButTappableButton {
            static let colorIsNil = "Color is nil"
            static func cannotCreateIcon(with iconName: String, configuration: String, andColor color: String) -> String {
                return "Cannot create icon with iconName: \(iconName) and configuration: \(configuration) and color: \(color))"
            }
        }
    }
}
