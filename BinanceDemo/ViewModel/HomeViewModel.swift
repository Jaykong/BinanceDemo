//
//  HomeViewModel.swift
//  BinanceDemo
//
//  Created by home_iMac on 2018/7/4.
//  Copyright © 2018 EF Education. All rights reserved.
//

import Foundation
import SnapKit
import UIKit
class HomeViewModel {
    var product: BIProduct!
    // https://www.binance.com/exchange/public/product
    init(success: @escaping () -> ()) {
        DispatchQueue.global().async {
            let product = BIProduct(fromURL: "https://www.binance.com/exchange/public/product")
            self.product = product
            DispatchQueue.main.async {
                success()
            }
        }
    }
    
    lazy var titles: [String] = {
        [QuoteAsset.bnb.rawValue, QuoteAsset.btc.rawValue, QuoteAsset.eth.rawValue, QuoteAsset.usdt.rawValue]
        
    }()
    
    func dataum(for asset: QuoteAsset) -> [ItemCellModel] {
        return self.product.data.filter { (datum) -> Bool in
            datum.quoteAsset == asset
        }.map({ (datum) -> ItemCellModel in
            ItemCellModel(datum: datum)
        })
    }
}
