//
//  GameDetailViewController.swift
//  Switch Kite
//
//  Created by 神奇海螺 on 2018/5/14.
//  Copyright © 2018年 SQHL. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import TagListView

class GameDetailViewController: UIViewController {

    @IBOutlet weak var picsPageView: HZPageView!
    @IBOutlet weak var titleView: MainDetailTitleView!
    @IBOutlet weak var tagView: TagListView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var gameinfoView: MainDetailGameinfoView!
    @IBOutlet weak var pricesView: MainDetailPricesView!
    @IBOutlet weak var introduceView: MainDetailIntroduceView!
    
    var isLoad = true
    
    var gameListModel = GameListModel()
    fileprivate var detailModel = GameDetailModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initPreviewData()
        self.initData(appId: self.gameListModel.appid)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /// 初始化预览数据
    private func initPreviewData(){
        self.titleView.initData(gameTitle: self.gameListModel.titleZh, gameSale: "正在加载", gameGrade: self.gameListModel.rate)
        self.picsPageView.loadImages(images: [self.gameListModel.icon], vc: self)
        self.pricesView.lowPrice.text = "当前最低:\(self.gameListModel.price)"
        self.gameinfoView.initData(gameLanguage:0, gameSize: "0MB", gameNumber: 0, gameEntity: false, gameTry: false)
        self.infoLabel.text = self.gameListModel.titleZh
        self.introduceView.initData(gameIntroduce: self.gameListModel.titleZh)
    }
    
    
    private func initViewData(){
        self.titleView.initData(gameTitle: self.detailModel.titleZh, gameSale: self.detailModel.pubDate, gameGrade: self.detailModel.rate)
        self.infoLabel.text = self.detailModel.brief
        self.gameinfoView.initData(gameLanguage: self.detailModel.chineseVer, gameSize: self.detailModel.size, gameNumber: self.detailModel.players, gameEntity: self.detailModel.entity, gameTry: self.detailModel.demo)
        self.introduceView.initData(gameIntroduce: self.detailModel.detail)
        self.tagView.addTags(self.detailModel.category)
        self.pricesView.initData(dataSource: self.detailModel.prices)
    }

}

extension GameDetailViewController{
    private func initData(appId:String){
        let lock = NSLock()
        self.DispatchAfter(after: 1) {
            lock.lock()
            if (self.isLoad){
                SVProgressHUD.show(withStatus: "正在加载\(self.gameListModel.titleZh)数据")
            }
            lock.unlock()
        }
        Alamofire.request("https://switch.applinzi.com/switchgame/gameInfo?appid=\(appId)", method: .get).responseJSON { (data) in
            lock.lock()
            self.isLoad = false
            lock.unlock()
            if data.result.isSuccess{
                if let dic = data.result.value as? [String:Any],let result = dic["data"] as? [String:Any], let game = result["game"] as? [String:Any]{
                    if let detailModel = GameDetailModel.deserialize(from: game){
                        if let prices = [GameDetailPricesModel].deserialize(from: result["prices"] as? [Any]){
                            //过滤空值
                            detailModel.prices = prices.compactMap{return $0}
                        }
                        self.detailModel = detailModel
                        self.initPicsView()
                        self.initViewData()
                        SVProgressHUD.dismiss()
                    }else{
                        SVProgressHUD.showError(withStatus: "解析JSON失败!")
                    }
                }else{
                    SVProgressHUD.showError(withStatus: "解析JSON失败!")
                }
            }else{
                SVProgressHUD.showError(withStatus: data.result.error?.localizedDescription)
            }
        }
        
    }
    
    
    fileprivate func initPicsView(){
        self.picsPageView.loadImages(images: self.detailModel.pics, vc: self)
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    /// GCD延时操作
    ///   - after: 延迟的时间
    ///   - handler: 事件
    public func DispatchAfter(after: Double, handler:@escaping ()->())
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + after) {
            handler()
        }
    }
}
