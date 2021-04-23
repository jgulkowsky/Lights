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
        bindToVMPlayPauseButtonIcon()
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
            self?.view.backgroundColor = color
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
    
    private func addTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer()
        view.addGestureRecognizer(tapGesture)

        tapGesture.rx.event.bind(onNext: { [weak self] _ in
            self?.vm.onScreenTap()
        }).disposed(by: disposeBag)
    }
}
