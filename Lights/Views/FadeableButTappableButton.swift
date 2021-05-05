//
//  FadeableButTappableButton.swift
//  Lights
//
//  Created by Jan Gulkowski on 05/05/2021.
//

import UIKit
import RxSwift

class FadeableButTappableButton: UIView {
    
    private let button = UIButton()
    
    private var animator = UIViewPropertyAnimator()
    
//    private enum State {
//        case visible, fadingOut, hidden, showingUp
//    }
    
    //private var state = State.visible
    
    private let disposeBag = DisposeBag()
    
    func setup(withName iconName: String,
               andConfiguration configuration: UIImage.Configuration?,
               andColor color: UIColor?,
               andTapHandlerOnButtonFullyOpaque tapHandlerOnButtonFullyOpaque: @escaping () -> (),
               andTapHandlerOnButtonSemiTransparent tapHandlerOnButtonSemiTransparent: @escaping () -> ()) {
        setupButtonConstraints()
        setupButtonIcon(iconName, configuration, color)
        setupButtonTapHandler(tapHandlerOnButtonFullyOpaque)
        
        setupBackgroundColor()
        setupBackgroundTapHandler(tapHandlerOnButtonSemiTransparent)
    }
    
    func fadeOut() {
        //todo: we don't use states - and vm
        button.isUserInteractionEnabled = false
        animator.stopAnimation(true)
        animator = UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: Double(button.alpha) * Durations.ViewModel.uiVisibilityChange,
            delay: .zero,
            options: .curveEaseInOut,
            animations: { [weak self] in
                self?.button.alpha = 0
            },
            completion: { [weak self] _ in
                self?.isUserInteractionEnabled = false
            })
    }
    
    func fadeIn() {
        //todo: we don't use states - and vm
        self.isUserInteractionEnabled = true
        animator.stopAnimation(true)
        animator = UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: Double(1.0 - button.alpha) * Durations.ViewModel.uiVisibilityChange,
            delay: .zero,
            options: .curveEaseInOut,
            animations: { [weak self] in
                self?.button.alpha = 1
            },
            completion: { [weak self] _ in
                self?.button.isUserInteractionEnabled = true
            })
    }
    
    private func setupButtonConstraints() {
        addSubview(button)
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupButtonTapHandler(_ handler: @escaping () -> ()) {
        button.rx.tap.bind { _ in
            handler()
        }.disposed(by: disposeBag)
    }
    
    private func setupButtonIcon(_ iconName: String, _ configuration: UIImage.Configuration?, _ color: UIColor?) {
        if let icon = UIImage(systemName: iconName, withConfiguration: configuration) {
            let tintedIcon = icon.withRenderingMode(.alwaysTemplate)
            button.setImage(tintedIcon, for: .normal)
            button.setImage(tintedIcon, for: .highlighted)
            button.tintColor = color
        } else {
            //todo: first of all - it will not rather happen ever!
            //todo: log error
            fatalError("Cannot create icon with iconName: \(iconName) and configuration: \(String(describing: configuration)) and color: \(String(describing: color))") //todo: fatalErrors are not the best way out...
        }
    }
    
    private func setupBackgroundColor() {
        self.backgroundColor = .clear
    }
    
    private func setupBackgroundTapHandler(_ handler: @escaping () -> ()) {
        let tapGesture = UITapGestureRecognizer()
        self.addGestureRecognizer(tapGesture)

        tapGesture.rx.event.bind(onNext: { _ in
            handler()
        }).disposed(by: disposeBag)
    }
}
