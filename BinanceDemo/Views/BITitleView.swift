//
//  JKView.swift
//  BinanceDemo
//
//  Created by JayKong on 2018/7/2.
//  Copyright © 2018 EF Education. All rights reserved.
//

import SnapKit
import UIKit
class BITitleView: UIView {
    let scrollView = UIScrollView()
    let indicatorView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.red
        return v
    }()
    
    var btns: [UIButton] = []
    var stackView: UIStackView!
    
    init(numberOfItems: [String]) {
        super.init(frame: CGRect.zero)
        
        btns = numberOfItems.map { (item) -> UIButton in
            let btn = UIButton(type: .custom)
            btn.setTitle(item, for: .normal)
            btn.setTitleColor(UIColor.black, for: .normal)
            return btn
        }
        stackView = UIStackView(arrangedSubviews: btns)
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        
        addSubview(scrollView)
        
        scrollView.addSubview(stackView)
        scrollView.addSubview(indicatorView)
        
        scrollView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { maker in
            maker.leading.trailing.equalTo(self)
            maker.top.equalToSuperview()
        }
        
        indicatorView.snp.makeConstraints { maker in
            maker.top.equalTo(stackView.snp.bottom)
            maker.height.equalTo(2)
            maker.width.equalTo(50)
            centerXConstrait = maker.centerX.equalTo(btns[0].snp.centerX).constraint
        }
    }
    
    var centerXConstrait: Constraint!
    func updateIndicator(index: Int) {
        centerXConstrait.deactivate()
        indicatorView.snp.makeConstraints { maker in
            centerXConstrait = maker.centerX.equalTo(btns[index].snp.centerX).constraint
        }
        updateConstraintsIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
