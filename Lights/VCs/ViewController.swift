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
        bindToVMMode()
        addTapGestureRecognizer()
    }
    
    private func setupPlayPauseButton() {
        view.addSubview(playPauseButton)
        playPauseButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(40)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
            make.width.equalTo(100) //todo: use constants
        }
        
        playPauseButton.rx.tap.bind { [weak self] _ in
            self?.vm.onPlayPauseButtonTap()
        }.disposed(by: disposeBag)
    }
    
    private func bindToVMScreenColor() {
        vm.screenColor.asObservable().subscribe { [weak self] color in
            self?.view.backgroundColor = color
        }.disposed(by: disposeBag)
    }
    
    private func bindToVMMode() {
        vm.mode.asObservable().subscribe { [weak self] mode in
            self?.playPauseButton.setTitle(mode == .paused ? "Play" : "Pause", for: .normal)
            //todo: in future make it lighter than background
            //todo: in future use icons instead of titles
        }.disposed(by: disposeBag)
    }
    
    private func addTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer()
        view.addGestureRecognizer(tapGesture)

        tapGesture.rx.event.bind(onNext: { [weak self] _ in
            self?.vm.onScreenTap()
        }).disposed(by: disposeBag)
    }
}
