//
//  SizesAndOffsets.swift
//  Lights
//
//  Created by Jan Gulkowski on 23/04/2021.
//

import UIKit

struct SizesAndOffsets {
    struct ViewController {
        struct PlayPauseButton {
            static let bottomInset: CGFloat = 50
            static let height: CGFloat = 50 //this is responsible for clickable area size around the button
            static let width: CGFloat = 50 //this is responsible for clickable area size around the button
            static let iconSizeConfig = UIImage.SymbolConfiguration(pointSize: 45, weight: .regular, scale: .small)
        }
    }
}
