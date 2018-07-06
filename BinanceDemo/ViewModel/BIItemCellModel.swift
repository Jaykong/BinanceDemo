//
//  ItemCellModel.swift
//  BinanceDemo
//
//  Created by JayKong on 2018/7/4.
//  Copyright © 2018 EF Education. All rights reserved.
//

import Foundation

struct BIItemCellModel {
    let name: String
    let dollarValue: String
    let covertedValue: String
    let volume: String
    
    init(datum: Datum) {
        self.name = "\(datum.baseAsset)/\(datum.quoteAsset.rawValue)"
        
        let dollarValue = String(format: "%.2f", datum.tradedMoney / 10)
        
        let dollarNumber = NSNumber(value: Double(dollarValue)!)
        self.dollarValue = dollarNumber.dollarValue()!
        self.covertedValue = datum.purpleOpen
        let volumeInt = Int(Double(datum.volume)!)
        
        let formatter = NumberFormatter()
        formatter.locale = NSLocale.current // this ensures the right separator behavior
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.usesGroupingSeparator = true
        let formatedVolume = formatter.string(from: NSNumber(value: volumeInt))
        self.volume = "Vol \(formatedVolume!)"
    }
}
