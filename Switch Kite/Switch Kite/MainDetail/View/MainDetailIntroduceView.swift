//
//  MainDetailIntroduceView.swift
//  Switch Kite
//
//  Created by 神奇海螺 on 2018/5/15.
//  Copyright © 2018年 SQHL. All rights reserved.
//

import UIKit

class MainDetailIntroduceView: UIView {
    
    @IBOutlet weak var gameIntroduce: UILabel!
    
    func initData(gameIntroduce:String){
        if gameIntroduce == ""{
            self.gameIntroduce.text = "暂无详情介绍~喵"
        }else{
            self.gameIntroduce.text = gameIntroduce
        }
    }
}
