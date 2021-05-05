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
    
    private let playPauseButton = FadeableButTappableButton()
    private let disposeBag = DisposeBag()

    private var bgColorAnimator = UIViewPropertyAnimator()
    
    init(_ vm: ViewModel) {
//        print("\(Debug.Log.ViewController).init")
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
//        print("\(Debug.Log.ViewController).loadView")
        super.loadView()
        setupPlayPauseButton()
        bindToVMScreenColor()
        bindToVMPlayPauseButtonIcon()
        bindToVMUIVisibility()
        bindToVMMode()
        addTapGestureRecognizer()
    }
    
    private func setupPlayPauseButton() {
//        print("\(Debug.Log.ViewController).setupPlayPauseButton")
        view.addSubview(playPauseButton)
        playPauseButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(SizesAndOffsets.ViewController.PlayPauseButton.bottomInset)
            make.height.equalTo(SizesAndOffsets.ViewController.PlayPauseButton.height)
            make.centerX.equalToSuperview()
            make.width.equalTo(SizesAndOffsets.ViewController.PlayPauseButton.width)
        }
        
        playPauseButton.setup(withTapHandlerOnButtonFullyOpaque: { [weak self] in
            self?.vm.onPlayPauseButtonTapWhenItIsOpaque()
        }, andTapHandlerOnButtonSemiTransparent: { [weak self] in
            self?.vm.onPlayPauseButtonTapWhenItSemiTransparent()
        })
    }
    
    private func bindToVMScreenColor() {
//        print("\(Debug.Log.ViewController).bindToVMScreenColor")
        vm.screenColor.asObservable().subscribe { [weak self] color in
//            print("\(Debug.Log.ViewController).bindToVMScreenColor.subscribe")
            if (self?.vm.mode.value == .paused) {
                self?.view.backgroundColor = color.element
            } else {
                self?.startColorTransition(to: color.element)
            }
        }.disposed(by: disposeBag)
    }
    
    private func bindToVMPlayPauseButtonIcon() {
//        print("\(Debug.Log.ViewController).bindToVMPlayPauseButtonIcon")
        vm.playPauseButtonIconName.asObservable().subscribe { [weak self] playPauseButtonIconName in
//            print("\(Debug.Log.ViewController).bindToVMPlayPauseButtonIcon.subscribe")
            if let iconName = playPauseButtonIconName.element {
                self?.playPauseButton.setupIcon(withName: iconName,
                                                andConfiguration: SizesAndOffsets.ViewController.PlayPauseButton.iconSizeConfig,
                                                andColor: .white) //todo: in future make it lighter than background
            } else {
                //todo: first of all - it will not rather happen ever!
                //todo: log error
                fatalError("Nil value found in playPauseButtonIconName.element") //todo: fatalErrors are not the best way out...
            }
        }.disposed(by: disposeBag)
    }
    
    private func bindToVMUIVisibility() {
//        print("\(Debug.Log.ViewController).bindToVMUIVisibility")
        vm.uiVisibility.asObservable().subscribe { [weak self] uiVisibility in
//            print("\(Debug.Log.ViewController).bindToVMUIVisibility.subscribe")
            if uiVisibility.element == .hidden {
                self?.fadeUIOut()
            } else {
                self?.fadeUIIn()
            }
            //todo: when add more ui elements, put them into the container and use this binding to control whole container instead of single elements - such as playPauseButton
        }.disposed(by: disposeBag)
    }
    
    private func bindToVMMode() {
//        print("\(Debug.Log.ViewController).bindToVMMode")
        vm.mode.asObservable()
            .filter { $0 == .paused }
            .subscribe { [weak self] mode in
//                print("\(Debug.Log.ViewController).bindToVMMode.subscribe")
                guard let `self` = self else {
                    //todo: first of all - it will not rather happen ever!
                    //todo: log error
                    fatalError("self is nil!") //todo: fatalErrors are not the best way out...
                }
                
                if self.vm.playPauseButtonTappedAtLeastOnce {
                    self.bgColorAnimator.stopAnimation(true)
                    self.vm.onColorTransitionStopped(at: self.view.backgroundColor)
                }
        }.disposed(by: disposeBag)
    }
    
    private func addTapGestureRecognizer() {
//        print("\(Debug.Log.ViewController).addTapGestureRecognizer")
        let tapGesture = UITapGestureRecognizer()
        view.addGestureRecognizer(tapGesture)

        tapGesture.rx.event.bind(onNext: { [weak self] _ in
            self?.vm.onScreenTap()
        }).disposed(by: disposeBag)
    }
    
    private func fadeUIOut() {
//        print("\(Debug.Log.ViewController).fadeUIOut")
        playPauseButton.fadeOut()
    }
    
    private func fadeUIIn() {
//        print("\(Debug.Log.ViewController).fadeUIIn")
        playPauseButton.fadeIn()
    }
    
    private func startColorTransition(to color: UIColor?) {
//        print("\(Debug.Log.ViewController).startColorTransition")
        bgColorAnimator = UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: Durations.ViewModel.colorTransition,
            delay: .zero,
            options: [.curveLinear, .allowUserInteraction],
            animations: { [weak self] in
                self?.view.backgroundColor = color
            },
            completion: { [weak self] _ in
                self?.vm.onColorTransitionComplete()
            })
    }
    
    //todo: should animations be here? not rather in vm? they are also a part o logic - this applies to both fading out / in of the button and starting / stopping color transition of the view
    
    //todo: yep - I thnik next commit should be about moving as much as possible to viewModel
    
    //todo: and next after this should be about writting some test cases as our app starts to become slowly quite a complicated state machine
}

