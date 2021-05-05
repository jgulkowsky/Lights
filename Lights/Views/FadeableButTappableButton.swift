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
    private let disposeBag = DisposeBag()
    
    private var animator = UIViewPropertyAnimator()
    
    func setup(withTapHandlerOnButtonFullyOpaque tapHandlerOnButtonFullyOpaque: @escaping () -> (),
               andTapHandlerOnButtonSemiTransparent tapHandlerOnButtonSemiTransparent: @escaping () -> ()) {
//        print("\(Debug.Log.fadeableButTappableButton).setup")
        setupButtonConstraints()
        setupButtonTapHandler(tapHandlerOnButtonFullyOpaque)
        setupBackgroundColor()
        setupBackgroundTapHandler(tapHandlerOnButtonSemiTransparent)
    }
    
    func setupIcon(withName iconName: String, andConfiguration configuration: UIImage.Configuration?, andColor color: UIColor?) {
//        print("\(Debug.Log.fadeableButTappableButton).setupIcon")
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
    
    func fadeOut() {
//        print("\(Debug.Log.fadeableButTappableButton).fadeOut")
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
//        print("\(Debug.Log.fadeableButTappableButton).fadeIn")
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
//        print("\(Debug.Log.fadeableButTappableButton).setupButtonConstraints")
        addSubview(button)
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupButtonTapHandler(_ handler: @escaping () -> ()) {
//        print("\(Debug.Log.fadeableButTappableButton).setupButtonTapHandler")
        button.rx.tap.bind { _ in
            handler()
        }.disposed(by: disposeBag)
    }
    
    private func setupBackgroundColor() {
//        print("\(Debug.Log.fadeableButTappableButton).setupBackgroundColor")
        self.backgroundColor = .clear
    }
    
    private func setupBackgroundTapHandler(_ handler: @escaping () -> ()) {
//        print("\(Debug.Log.fadeableButTappableButton).setupBackgroundTapHandler")
        let tapGesture = UITapGestureRecognizer()
        self.addGestureRecognizer(tapGesture)

        tapGesture.rx.event.bind(onNext: { _ in
            handler()
        }).disposed(by: disposeBag)
    }
}
