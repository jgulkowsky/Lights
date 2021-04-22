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

    private let disposeBag = DisposeBag()
    
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

        tapGesture.rx.event.bind(onNext: { recognizer in
            print("tap")
        }).disposed(by: disposeBag)
    }
}
