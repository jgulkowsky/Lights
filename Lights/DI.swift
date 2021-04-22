//
//  DI.swift
//  Lights
//
//  Created by Jan Gulkowski on 23/04/2021.
//

import Foundation
import Swinject

var container: Container = {
    
    let container = Container()
    
    container.register(ViewModel.self) { r in
        let vm = ViewModel()
        return vm
    }
    
    container.register(ViewController.self) { r in
        let vc = ViewController(r.resolve(ViewModel.self)!)
        return vc
    }
    
    return container
}()
