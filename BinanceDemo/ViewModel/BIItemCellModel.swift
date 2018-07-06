//
//  ItemCellModel.swift
//  BinanceDemo
//
//  Created by JayKong on 2018/7/4.
//  Copyright © 2018 EF Education. All rights reserved.
//

import Foundation
import UIKit
struct BIItemCellModel {
    let name: NSAttributedString
    let dollarValue: String
    let covertedValue: String
    let volume: String
    
    init(datum: Datum) {
        let quoteAsset = "/\(datum.quoteAsset.rawValue)"
        let quote = "\(datum.baseAsset)\(quoteAsset)" as NSString
        
        let attri = NSMutableAttributedString(string: quote as String)
        let assetRange = quote.range(of: quoteAsset)
        attri.addAttribute(.foregroundColor, value: UIColor.nevada, range:assetRange )
        attri.addAttribute(.font, value: UIFont.systemFont(ofSize: 12), range: assetRange)
        
        self.name = attri
        
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
