//
//  ViewTransition.swift
//  Doctor24
//
//  Created by gabriel.jeong on 09/01/2020.
//  Copyright © 2020 JHH. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class ViewTransition {
    static let shared = ViewTransition()
    var root: UINavigationController!
    
    private let target = PublishRelay<Scene>()
    private let disposeBag = DisposeBag()
    
    init() {
        self.target
            .subscribe(onNext: { [weak self] scene in
                self?.transition(with: scene)
            }).disposed(by: self.disposeBag)
    }
    
    func execute(scene: Scene?) {
        guard let scene = scene else { return }
        self.target.accept(scene)
    }
}

// MARK: Private
extension ViewTransition {
    private func transition(with scene: Scene) {
        switch scene {
        case .main:
            let scenes = [scene]
            self.root.setViewControllers(scenes.map { $0.viewController }, animated: false)
            
        case .timePick:
            self.root.present(scene.viewController, animated: true, completion: nil)
            
        case .detail:
            let scene = scene
            self.root.topViewController!.present(scene.viewController, animated: true, completion: nil)
            
        case .around:
            self.root.topViewController!.present(scene.viewController, animated: true, completion: nil)
        }
    }
}


