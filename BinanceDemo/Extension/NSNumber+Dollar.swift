//
//  File.swift
//  BinanceDemo
//
//  Created by JayKong on 2018/7/5.
//  Copyright © 2018 EF Education. All rights reserved.
//

import Foundation
extension NSNumber {
    func dollarValue() -> String? {
        let formatter = NumberFormatter()
        formatter.locale = NSLocale.current
        formatter.numberStyle = .currency
        let formattedAmountSting = formatter.string(from: self)
        return formattedAmountSting
    }
}
