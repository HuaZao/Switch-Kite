//
//  pop.swift
//  Switch Kite
//
//  Created by 神奇海螺 on 2018/5/15.
//  Copyright © 2018年 SQHL. All rights reserved.
//

import UIKit

extension UIViewController{
    
    @IBAction func popAction(sender:Any){
        self.navigationController?.popViewController(animated: true)
    }
    
}
