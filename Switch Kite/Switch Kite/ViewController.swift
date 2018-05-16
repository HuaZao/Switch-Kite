//
//  ViewController.swift
//  Switch Kite
//
//  Created by 神奇海螺 on 2018/5/14.
//  Copyright © 2018年 SQHL. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import HandyJSON
import MJRefresh

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var dataSource = [GameListModel]()
    var page:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initMjRefresh()
        self.initPreviewData()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// 初始化预览数据
    private func initPreviewData(){
        let tempModel = GameListModel()
        tempModel.isWindless = true
        self.dataSource = [tempModel,tempModel,tempModel,tempModel,tempModel,tempModel,tempModel,tempModel]
        self.tableView.isUserInteractionEnabled = false
        self.tableView.reloadData()
        self.initData(offset: 0, limit: 10)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detail = segue.destination as? GameDetailViewController,let cell = sender as? GameCell,let index = self.tableView.indexPath(for: cell)?.row{
            detail.gameListModel = self.dataSource[index]
            detail.title = self.dataSource[index].titleZh
        }
    }
    
}


extension ViewController:UITableViewDelegate,UITableViewDataSource{
    
    private func initMjRefresh(){
        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { [unowned self]  in
            self.page = self.page + 1
            self.initData(offset: self.page * 10, limit: 10)
        })
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [unowned self]  in
            self.page = 0
            self.initData(offset: self.page, limit: 10)
            self.tableView.mj_footer.resetNoMoreData()
        })
    }
    
    private func initData(offset:Int,limit:Int){
        Alamofire.request("https://switch.applinzi.com/switchgame/list?discount=true&all=true&offset=\(offset)&limit=\(limit)", method: .get).responseJSON { (data) in
            self.tableView.isUserInteractionEnabled = true
            if data.result.isSuccess{
                if (self.page == 0){
                    self.dataSource.removeAll()
                }
                if let dic = data.result.value as? [String:Any],let result = dic["data"] as? [String:Any], let games = result["games"] as? [Any]{
                    if let games = [GameListModel].deserialize(from: games){
                        if games.count == 0{
                            self.tableView.mj_footer.endRefreshingWithNoMoreData()
                        }else{
                            games.forEach({ (object) in
                                if (object != nil){
                                    self.dataSource.append(object!)
                                }
                            })
                            self.tableView.reloadData()
                            self.tableView.mj_footer.endRefreshing()
                        }
                    }
                }else{
                    SVProgressHUD.showError(withStatus:"JSON解析错误")
                    self.tableView.mj_footer.endRefreshing()
                }
            }else{
                SVProgressHUD.showError(withStatus:data.result.error?.localizedDescription)
                self.tableView.mj_footer.endRefreshing()
            }
            self.tableView.mj_header.endRefreshing()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as! GameCell
        cell.loadCellData(model: self.dataSource[indexPath.row])
        return cell
    }
    
    
}

let kWindlessViewTag = 91997
extension UIView {
    /// 为视图添加弱网效果
    ///
    /// - Parameter isWindless: 是否为弱网状态
    func windless(_ isWindless: Bool = true) {
        var windLessView: UIView? = self.viewWithTag(kWindlessViewTag)
        if isWindless {
            if windLessView == nil {
                // 添加弱网视图
                windLessView = UIView(frame: self.frame)
                windLessView!.backgroundColor = UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)
                windLessView!.tag = kWindlessViewTag
                windLessView?.layer.position    = CGPoint(x: 0, y: 0)
                windLessView?.layer.anchorPoint = CGPoint(x: 0, y: 0)
                self.addSubview(windLessView!)
            }
            // 添加动画
            let random = CGFloat(self.randomNum(start: 4, end: 6)) / 10.0
            let minW = self.bounds.size.width * random
            let maxW = self.bounds.size.width * 1.0
            let animation = CABasicAnimation(keyPath: "bounds.size.width")
            animation.duration      = 1
            animation.repeatCount   = MAXFLOAT
            animation.autoreverses  = true
            animation.fromValue     = CGFloat(minW)
            animation.toValue       = CGFloat(maxW)
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            windLessView!.layer.add(animation, forKey: "WindlessAnimation")
        } else {
            guard windLessView != nil else {
                return
            }
            // 移除弱网视图
            windLessView?.removeFromSuperview()
        }
    }
    
    /// 获取（start~end）的随机数(为了让动画更好看)
    func randomNum(start: Int, end: Int) -> Int {
        var temp = Int(arc4random_uniform(UInt32(end))) + 1
        if temp < start {
            temp = self.randomNum(start: start, end: end)
        }
        return temp
    }
}

