//
//  GameCell.swift
//  Switch Kite
//
//  Created by 神奇海螺 on 2018/5/14.
//  Copyright © 2018年 SQHL. All rights reserved.
//

import UIKit
import Kingfisher

class GameCell: UITableViewCell {
    //图标
    @IBOutlet weak var iconView: UIImageView!
    //标题
    @IBOutlet weak var titleLabel: UILabel!
    //英文标题
    @IBOutlet weak var titleEnLabel: UILabel!
    //价格标签
    @IBOutlet weak var priceLabel: UILabel!
    //国家
    @IBOutlet weak var countryLabel: UILabel!
    //折扣
    @IBOutlet weak var discountLabel: UILabel!
    //剩余折扣天数
    @IBOutlet weak var disResidueLabel: UILabel!
    //游戏评分
    @IBOutlet weak var gradeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func loadCellData(model:GameListModel){
        self.discountLabel.isHidden = model.isWindless
        self.gradeLabel.isHidden = model.isWindless
        if (model.isWindless){
            self.setupContent(isWindless: true)
            self.iconView.image =  #imageLiteral(resourceName: "占位图1X1")
            self.titleLabel.text = "                                  "
            self.titleEnLabel.text = "                                  "
            self.countryLabel.text = "                                  "
            self.disResidueLabel.text = "                                  "
            self.priceLabel.text = "           "
        }else{
            self.setupContent(isWindless: false)
            if let url = URL(string: model.icon){
                self.iconView.kf.setImage(with: url,placeholder:#imageLiteral(resourceName: "占位图1X1"),options: [KingfisherOptionsInfoItem.transition(ImageTransition.fade(0.2))])

            }
            self.titleLabel.text = model.titleZh
            self.titleEnLabel.text = model.title
            self.countryLabel.text = "发售地区:\(model.country)"
            self.discountLabel.text = " \(model.cutoff)%折扣  "
            self.disResidueLabel.text = "剩余天数:\(model.leftDiscount)"
            self.priceLabel.text = "￥\(model.price)"
            if model.rate == 0 {
                self.gradeLabel.isHidden = true
            }else{
                self.gradeLabel.isHidden = false
                self.gradeLabel.text = "\(model.rate)"
            }
        }
    }
    
    func setupContent(isWindless:Bool){
        self.updateContenView(isWindless: isWindless)
        self.isUserInteractionEnabled = !isWindless
    }

    func updateContenView(isWindless: Bool) {
//        self.iconView.windless(isWindless)
        self.titleLabel.windless(isWindless)
        self.titleEnLabel.windless(isWindless)
        self.countryLabel.windless(isWindless)
        self.disResidueLabel.windless(isWindless)
        self.priceLabel.windless(isWindless)
    }
    
}
