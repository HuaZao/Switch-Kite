//
//  MainDetailTitleView.swift
//  Switch Kite
//
//  Created by 神奇海螺 on 2018/5/15.
//  Copyright © 2018年 SQHL. All rights reserved.
//

import UIKit

class MainDetailTitleView: UIView {
    
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var gameSale: UILabel!
    @IBOutlet weak var gameGrade: UILabel!
    
    func initData(gameTitle:String,gameSale:String,gameGrade:Int){
        self.gameTitle.text = gameTitle
        self.gameSale.text = "发售日期:\(gameSale)"
        self.gameGrade.text = "\(gameGrade)"
    }
    
}
