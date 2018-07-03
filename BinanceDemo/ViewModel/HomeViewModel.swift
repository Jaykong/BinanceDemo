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
    
    struct ItemCellModel {
        let name:String
        let dollarValue:String
        let covertedValue:String
        let volume:String
        
        init(datum:Datum) {
            self.name = "\(datum.baseAsset)/\(datum.quoteAsset)"
            let dollarValue = String.init(format: ".2f", datum.tradedMoney / 10)
            self.dollarValue = dollarValue
            self.covertedValue = datum.purpleOpen
            let volumeInt = Int(datum.volume)
            let numberFomat = NumberFormatter()
            numberFomat.decimalSeparator = ","
            
            formatedVolume = numberFomat.string(from: NSNumber(value: volumeInt!))
           
            self.volume = datum.volume
        }
    }
    
    func dataum(for asset:QuoteAsset) -> [Datum] {
        return self.product.data.filter { (datum) -> Bool in
            return datum.quoteAsset == asset
        }
    }
    
    

}
