//
//  CollectionViewCell.swift
//  BinanceDemo
//
//  Created by JayKong on 2018/7/2.
//  Copyright © 2018 EF Education. All rights reserved.
//

import UIKit

class BIHomeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var tableView: UITableView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let nib = UINib(nibName: "BIItemCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ItemCell")
    }

}
