//
//  GameListModel.swift
//  Switch Kite
//
//  Created by 神奇海螺 on 2018/5/14.
//  Copyright © 2018年 SQHL. All rights reserved.
//

import UIKit
import HandyJSON

class GameListModel: NSObject,HandyJSON{
    var appid: String = String()
    var chineseVer: Int = 0
    var country: String = String()
    var cutoff: Int = 0
    var discountEnd: Int = 0
    var icon: String = String()
    var leftDiscount: String = String()
    var price: CGFloat = 0.00
    var priceRaw: CGFloat = 0.00
    var rate: Int = 0
    var title: String = String()
    var titleZh: String = String()
    var isWindless:Bool = false
    required override init() {
        
    }
    
}
