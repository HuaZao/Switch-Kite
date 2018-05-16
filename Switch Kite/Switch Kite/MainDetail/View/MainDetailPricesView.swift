//
//  MainDetailPricesView.swift
//  Switch Kite
//
//  Created by 神奇海螺 on 2018/5/15.
//  Copyright © 2018年 SQHL. All rights reserved.
//

import UIKit

class MainDetailPricesView: UIView,UITableViewDelegate,UITableViewDataSource{
    
    var priceHeight:CGFloat = 215
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var moreButton: UIButton!
    @IBOutlet  weak var lowPrice: UILabel!
    @IBOutlet private weak var priceLayoutHeight: NSLayoutConstraint!
    private var dataSource = [GameDetailPricesModel]()
    
    
    @IBAction func showMorePrice(sender:UIButton){
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            sender.setTitle("收起更多商店价格", for: .normal)
            self.priceLayoutHeight.constant = CGFloat(64 + 50 * self.dataSource.count)
        }else{
            sender.setTitle("展开更多商店价格", for: .normal)
            self.priceLayoutHeight.constant = CGFloat(priceHeight)
        }
      
    }
    
    
    
    
    func initData(dataSource:[GameDetailPricesModel]) {
        if dataSource.count < 3{
            self.priceHeight = CGFloat(64 + 50 * dataSource.count)
            self.priceLayoutHeight.constant = self.priceHeight
            self.moreButton.setTitle("", for: .normal)
            self.moreButton.isEnabled = false
        }
        self.dataSource = dataSource.sorted(by: { (object1, object2) -> Bool in
            if let floatPrice1 = Float(object1.price),let floatPrice2 = Float(object2.price){
                return floatPrice1 < floatPrice2
            }else{
                return object1.price < object2.price
            }
        })
        //找出最低价
        if let low = self.dataSource.first{
            self.lowPrice.text = "当前最低:￥\(low.price)"
        }
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "priceCell", for: indexPath) as! MainPriceCell
        cell.loadData(model: self.dataSource[indexPath.row])
        return cell
    }
    
    
}
