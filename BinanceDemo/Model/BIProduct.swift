//
//  BIProduct.swift
//  BinanceDemo
//
//  Created by JayKong on 2018/7/3.
//  Copyright © 2018 EF Education. All rights reserved.
//

import Foundation
struct BIProduct: Codable {
    let data: [Datum]
}

struct Datum: Codable {
    let symbol: String
    let quoteAssetName: QuoteAssetName
    let tradedMoney: Double
    let baseAssetUnit: BaseAssetUnit
    let baseAssetName, baseAsset: String
    let tickSize: TickSize
    let prevClose, activeBuy: Double
    let high: String
    let lastAggTradeID: Int
    let low: String
    let matchingUnitType: MatchingUnitType
    let close: String
    let quoteAsset: QuoteAsset
    let productType: JSONNull?
    let active: Bool
    let minTrade, activeSell: Double
    let withdrawFee: WithdrawFee
    let volume: String
    let decimalPlaces: Int
    let quoteAssetUnit: QuoteAssetUnit
    let purpleOpen: String
    let status: Status
    let minQty: Double

    enum CodingKeys: String, CodingKey {
        case symbol, quoteAssetName, tradedMoney, baseAssetUnit, baseAssetName, baseAsset, tickSize, prevClose, activeBuy, high
        case lastAggTradeID = "lastAggTradeId"
        case low, matchingUnitType, close, quoteAsset, productType, active, minTrade, activeSell, withdrawFee, volume, decimalPlaces, quoteAssetUnit
        case purpleOpen = "open"
        case status, minQty
    }
}

enum BaseAssetUnit: String, Codable {
    case empty = ""
    case purple = "฿"
    case ł = "Ł"
    case ξ = "Ξ"
}

enum MatchingUnitType: String, Codable {
    case standard = "STANDARD"
}

enum QuoteAsset: String, Codable {
    case bnb = "BNB"
    case btc = "BTC"
    case eth = "ETH"
    case usdt = "USDT"
}

enum QuoteAssetName: String, Codable {
    case binanceCoin = "Binance Coin"
    case bitcoin = "Bitcoin"
    case ethereum = "Ethereum"
    case tetherUS = "TetherUS"
}

enum QuoteAssetUnit: String, Codable {
    case empty = ""
    case purple = "฿"
    case ξ = "Ξ"
}

enum Status: String, Codable {
    case trading = "TRADING"
}

enum TickSize: String, Codable {
    case the000000001 = "0.00000001"
    case the00000001 = "0.0000001"
    case the0000001 = "0.000001"
    case the000001 = "0.00001"
    case the00001 = "0.0001"
    case the0001 = "0.001"
    case the001 = "0.01"
}

enum WithdrawFee: String, Codable {
    case the0 = "0"
}

// MARK: Convenience initializers

extension BIProduct {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(BIProduct.self, from: data) else { return nil }
        self = me
    }

    init?(_ json: String, using encoding: String.Encoding = .utf8) {
        guard let data = json.data(using: encoding) else { return nil }
        self.init(data: data)
    }

    init?(fromURL url: String) {
        guard let url = URL(string: url) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        self.init(data: data)
    }

    var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }

    var json: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

extension Datum {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(Datum.self, from: data) else { return nil }
        self = me
    }

    init?(_ json: String, using encoding: String.Encoding = .utf8) {
        guard let data = json.data(using: encoding) else { return nil }
        self.init(data: data)
    }

    init?(fromURL url: String) {
        guard let url = URL(string: url) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        self.init(data: data)
    }

    var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }

    var json: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

// MARK: Encode/decode helpers

class JSONNull: Codable {
    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
