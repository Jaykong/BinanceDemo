//
//  HomeViewModel.swift
//  BinanceDemo
//
//  Created by home_iMac on 2018/7/4.
//  Copyright © 2018 EF Education. All rights reserved.
//

import Foundation
struct HomeViewModel {
    var product : BIProduct!
    
    init() {
        let path = Bundle.main.path(forResource: "test", ofType: "json")
        do {
            if let path = path {
                let contents = try String(contentsOfFile: path)
                if let product = BIProduct(contents) {
                    self.product = product
                }
            }

        } catch  {
            print(error)
        }
        
    }
    lazy var titles: [String] = {
        return         [QuoteAsset.bnb.rawValue,QuoteAsset.btc.rawValue,QuoteAsset.eth.rawValue,QuoteAsset.usdt.rawValue]

    }()
    
    
    func dataum(for asset:QuoteAsset) -> [ItemCellModel] {
        return self.product.data.filter { (datum) -> Bool in
            return datum.quoteAsset == asset
            }.map({ (datum) -> ItemCellModel in
                return ItemCellModel(datum: datum)
            })
    }
    
    

}
