//
//  File.swift
//  BinanceDemo
//
//  Created by JayKong on 2018/7/5.
//  Copyright © 2018 EF Education. All rights reserved.
//

import Foundation
import UIKit
extension UICollectionViewFlowLayout {
    func setup() {
        scrollDirection = .horizontal
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
    }
}

extension UICollectionView {
    func setup() {
        bounces = false
        isPagingEnabled = true
        backgroundColor = UIColor.black
        registerNib()
    }
    
    func registerNib() {
        let nib = UINib(nibName: "BIHomeCollectionViewCell", bundle: nil)
        register(nib, forCellWithReuseIdentifier: "CollectionViewCell")
    }
}

extension UIViewController {
    func removeChild(_ controller: UIViewController) {
        controller.willMove(toParentViewController: nil)
        controller.view.removeFromSuperview()
        controller.removeFromParentViewController()
    }
    
    func addChild(_ controller: UIViewController) {
        view.addSubview(controller.view)
        controller.view.frame = view.bounds
        addChildViewController(controller)
        controller.didMove(toParentViewController: self)
    }
}
