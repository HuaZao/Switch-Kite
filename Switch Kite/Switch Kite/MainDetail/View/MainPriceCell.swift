//
//  MainPriceCell.swift
//  Switch Kite
//
//  Created by 神奇海螺 on 2018/5/15.
//  Copyright © 2018年 SQHL. All rights reserved.
//

import UIKit

class MainPriceCell: UITableViewCell {
    
    @IBOutlet weak var locationPrice: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var sale: UILabel!
    @IBOutlet weak var region: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func loadData(model:GameDetailPricesModel){
        self.region.text = model.country
        self.locationPrice.text = "(\(model.coinName):\(model.originPrice))"
        self.price.text = "￥\(model.price)"
        if model.cutoff == 0{
            self.sale.isHidden = true
        }else{
            self.sale.isHidden = false
            self.sale.text = "  \(model.cutoff)%折扣  "
        }
    }
    
}
