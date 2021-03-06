//
//  ItemCell.swift
//  BinanceDemo
//
//  Created by JayKong on 2018/7/2.
//  Copyright © 2018 EF Education. All rights reserved.
//

import UIKit

class BIItemCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var convertedValue: UILabel!
    
    @IBOutlet weak var dollarValue: UILabel!
    @IBOutlet weak var volumnLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.backgroundColor = UIColor.black
        self.backgroundColor = UIColor.black
        nameLbl.textColor = UIColor.white
        convertedValue.textColor = UIColor.white
        volumnLbl.textColor = UIColor.nevada
        dollarValue.textColor = UIColor.nevada
        volumnLbl.font = UIFont.systemFont(ofSize: 12)
        dollarValue.font = UIFont.systemFont(ofSize: 12)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(with model:BIItemCellModel) {
        self.nameLbl.attributedText = model.name
        self.convertedValue.text = model.covertedValue
        self.dollarValue.text = model.dollarValue
        self.volumnLbl.text = model.volume
    }
}
