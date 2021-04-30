//
//  ViewController.swift
//  Lights
//
//  Created by Jan Gulkowski on 22/04/2021.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class ViewController: UIViewController {

    private var vm: ViewModel!
    
    private let disposeBag = DisposeBag()
    private let playPauseButton = UIButton()
    
    private var uiAnimator = UIViewPropertyAnimator()
    private var bgColorAnimator = UIViewPropertyAnimator()
    
    init(_ vm: ViewModel) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        setupPlayPauseButton()
        bindToVMScreenColor()
        bindToVMPlayPauseButtonIcon()
        bindToVMUIVisibility()
        bindToVMMode()
        addTapGestureRecognizer()
    }
    
    private func setupPlayPauseButton() {
        view.addSubview(playPauseButton)
        playPauseButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(SizesAndOffsets.ViewController.PlayPauseButton.bottomInset)
            make.height.equalTo(SizesAndOffsets.ViewController.PlayPauseButton.height)
            make.centerX.equalToSuperview()
            make.width.equalTo(SizesAndOffsets.ViewController.PlayPauseButton.width)
        }
        
        playPauseButton.rx.tap.bind { [weak self] _ in
            self?.vm.onPlayPauseButtonTap()
        }.disposed(by: disposeBag)
    }
    
    private func bindToVMScreenColor() {
        vm.screenColor.asObservable().subscribe { [weak self] color in
            print("bindToVMScreenColor.subscribe")
            if (self?.vm.mode.value == .paused) {
                self?.view.backgroundColor = color.element
            } else {
                self?.startColorTransition(to: color.element)
            }
        }.disposed(by: disposeBag)
    }
    
    private func bindToVMPlayPauseButtonIcon() {
        vm.playPauseButtonIconName.asObservable().subscribe { [weak self] playPauseButtonIconName in
            if let iconName = playPauseButtonIconName.element,
               let icon = UIImage(systemName: iconName, withConfiguration: SizesAndOffsets.ViewController.PlayPauseButton.iconSizeConfig) {
                let tintedIcon = icon.withRenderingMode(.alwaysTemplate)
                self?.playPauseButton.setImage(tintedIcon, for: .normal)
                self?.playPauseButton.setImage(tintedIcon, for: .highlighted)
                self?.playPauseButton.tintColor = .white //todo: in future make it lighter than background
            } else {
                //todo: first of all - it will not rather happen ever!
                //todo: log error
                fatalError("Icon is nil!") //todo: fatalErrors are not the best way out...
            }
        }.disposed(by: disposeBag)
    }
    
    private func bindToVMUIVisibility() {
        vm.uiVisibility.asObservable().subscribe { [weak self] uiVisibility in
            if uiVisibility.element == .hidden {
                self?.fadeUIOut()
            } else {
                self?.fadeUIIn()
            }
            //todo: when add more ui elements, put them into the container and use this binding to control whole container instead of single elements - such as playPauseButton
        }.disposed(by: disposeBag)
    }
    
    private func bindToVMMode() {
        vm.mode.asObservable()
            .filter { $0 == .paused }
            .subscribe { [weak self] mode in
                guard let `self` = self else {
                    //todo: first of all - it will not rather happen ever!
                    //todo: log error
                    fatalError("self is nil!") //todo: fatalErrors are not the best way out...
                }
                
                if self.vm.playPauseButtonTappedAtLeastOnce {
                    print("bindToVMMode.subscribe")
                    self.bgColorAnimator.stopAnimation(true)
                    self.vm.onColorTransitionStopped(at: self.view.backgroundColor)
                }
        }.disposed(by: disposeBag)
    }
    
    private func addTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer()
        view.addGestureRecognizer(tapGesture)

        tapGesture.rx.event.bind(onNext: { [weak self] _ in
            self?.vm.onScreenTap()
        }).disposed(by: disposeBag)
    }
    
    private func fadeUIOut() {
        uiAnimator.stopAnimation(true)
        let duration = Double(playPauseButton.alpha) * Durations.ViewModel.uiVisibilityChange
        uiAnimator = UIViewPropertyAnimator(duration: duration, curve: .easeInOut) { [weak self] in
            self?.playPauseButton.alpha = 0
        }
        uiAnimator.startAnimation()
        
        //todo: you can try using runningPropertyAnimatorWithDuration - it's animator but with already started animation - so you don't have to remember about starting the animation - and it happened that you forgot about it and wondering why the hell it's not working xd
    }
    
    private func fadeUIIn() {
        uiAnimator.stopAnimation(true)
        let duration = Double(1.0 - playPauseButton.alpha) * Durations.ViewModel.uiVisibilityChange
        uiAnimator = UIViewPropertyAnimator(duration: duration, curve: .easeInOut) { [weak self] in
            self?.playPauseButton.alpha = 1
        }
        uiAnimator.startAnimation()
    }
    
    private func startColorTransition(to color: UIColor?) {
        print("startColorTransition")
        bgColorAnimator = UIViewPropertyAnimator(duration: Durations.ViewModel.colorTransition, curve: .linear) { [weak self] in
            self?.view.backgroundColor = color
        }
        bgColorAnimator.addCompletion { [weak self] _ in
            self?.vm.onColorTransitionComplete()
        }
        bgColorAnimator.startAnimation()
    }
    
    //todo: should animations be here? not rather in vm? they are also a part o logic - this applies to both fading out / in of the button and starting / stopping color transition of the view
    
    //todo: yep - I thnik next commit should be about moving as much as possible to viewModel
    
    //todo: and next after this should be about writting some test cases as our app starts to become slowly quite a complicated state machine
}
