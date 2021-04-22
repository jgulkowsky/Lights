//
//  ViewController.swift
//  Lights
//
//  Created by Jan Gulkowski on 22/04/2021.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    private var vm: ViewModel!
    
    private let disposeBag = DisposeBag()
    
    init(_ vm: ViewModel) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        setupInitialColor()
        addTapGestureRecognizer()
    }
    
    private func setupInitialColor() {
        view.backgroundColor = .systemPurple
    }
    
    private func addTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer()
        view.addGestureRecognizer(tapGesture)

        tapGesture.rx.event.bind(onNext: { [weak self] _ in
            self?.vm.onScreenTap()
        }).disposed(by: disposeBag)
    }
}
