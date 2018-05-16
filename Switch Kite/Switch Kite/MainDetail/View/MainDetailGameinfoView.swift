//
//  MainDetailGameinfoView.swift
//  Switch Kite
//
//  Created by 神奇海螺 on 2018/5/15.
//  Copyright © 2018年 SQHL. All rights reserved.
//

import UIKit

class MainDetailGameinfoView: UIView {

    @IBOutlet weak var gameLanguage: UILabel!
    @IBOutlet weak var gameSize: UILabel!
    @IBOutlet weak var gameNumber: UILabel!
    @IBOutlet weak var gameEntity: UILabel!
    @IBOutlet weak var gameTry: UILabel!

    func initData(gameLanguage:Int,gameSize:String,gameNumber:Int,gameEntity:Bool,gameTry:Bool){
        switch gameLanguage {
        case 1:
            self.gameLanguage.text = "全区"
        default:
            self.gameLanguage.text = "无"
        }
        self.gameSize.text = gameSize
        self.gameNumber.text = "\(gameNumber)"
        self.gameEntity.text = gameEntity ? "有":"无"
        self.gameTry.text = gameTry ? "有":"无"

    }
}
