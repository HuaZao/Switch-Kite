//
//  HZPageView.swift
//  Switch Kite
//
//  Created by 神奇海螺 on 2018/5/14.
//  Copyright © 2018年 SQHL. All rights reserved.
//

import UIKit
import Reusable
import Kingfisher
import KKPhotoBrowser

class HZPageView: UIView,NibOwnerLoadable{
    
    @IBOutlet weak var touchButton: UIButton!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate var dataSource = [String]()
    
    fileprivate var selectorIndex = 0
    
    fileprivate weak var vc:UIViewController?
    
    fileprivate var timer:DispatchSourceTimer?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadNibContent()
        self.collectionView.register(cellType: PageViewCell.self)
        self.setCollectViewLayout()
        self.setTouch()
    }
    
    func loadImages(images:[String],vc:UIViewController){
        self.vc = vc
        self.dataSource = images
        if let object = self.dataSource.first,let url = URL(string:object){
            self.mainImageView.kf.setImage(with: url,placeholder:UIImage(named: "占位图1.3X1.3"))
        }
        self.collectionView.reloadData()
        if self.dataSource.count > 1{
            self.autoScroller(timeInterval: 6.5)
        }
    }
    
    private func autoScroller(timeInterval:Double){
        let indexLock = NSLock()
        self.timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        self.timer?.schedule(deadline: DispatchTime.now() + timeInterval, repeating: timeInterval)
        self.timer?.setEventHandler {
            indexLock.lock()
            //最后一张
            if self.selectorIndex + 1 == self.dataSource.count{
                self.selectorIndex = -1
            }
            DispatchQueue.main.async {
                self.selectorIndex = self.selectorIndex + 1
                let indexPath = IndexPath(item: self.selectorIndex, section: 0)
                if let url = URL(string: self.dataSource[self.selectorIndex]){
                    self.mainImageView.kf.setImage(with: url,placeholder:UIImage(named: "占位图1.3X1.3"))
                }
                self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
                self.collectionView.reloadData()
                indexLock.unlock()
            }
            if self.vc == nil{
                self.timer?.cancel()
            }
        }
        self.timer?.resume()
    }
    
    private func setTouch(){
        let swipeUp = UISwipeGestureRecognizer(target:self, action:#selector(swipe(_:)))
        swipeUp.direction = .left
        self.touchButton.addGestureRecognizer(swipeUp)
        let swipeDown = UISwipeGestureRecognizer(target:self, action:#selector(swipe(_:)))
        swipeDown.direction = .right
        self.touchButton.addGestureRecognizer(swipeDown)
    }

    @IBAction func mainPicAction(_ sender: UIButton) {
        let browserVC = KKPhotoBrowserController(selectedIndex: 0, urls: [self.dataSource[self.selectorIndex]], parentImageViews:[self.mainImageView])
        self.vc?.present(browserVC, animated: true, completion: nil)
    }
    
    @objc func swipe(_ recognizer:UISwipeGestureRecognizer){
        //暂停定时器
        self.timer?.suspend()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 8) {
            self.timer?.resume()
        }
        if recognizer.direction == .left{
            if self.selectorIndex + 1 != self.dataSource.count{
                self.selectorIndex = self.selectorIndex + 1
                let indexPath = IndexPath(item: self.selectorIndex, section: 0)
                if let url = URL(string: self.dataSource[self.selectorIndex]){
                    self.mainImageView.kf.setImage(with: url,placeholder:UIImage(named: "占位图1.3X1.3"))
                }
                self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
            }
        }else if recognizer.direction == .right{
            if self.selectorIndex != 0{
                self.selectorIndex = self.selectorIndex - 1
                let indexPath = IndexPath(item: self.selectorIndex, section: 0)
                if let url = URL(string: self.dataSource[self.selectorIndex]){
                    self.mainImageView.kf.setImage(with: url,placeholder:UIImage(named: "占位图1.3X1.3"))
                }
                self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
            }
        }
        self.collectionView.reloadData()
    }
    
    
    private func setCollectViewLayout(){
        //列数
        let columnsNum = 3
        self.collectionView?.backgroundColor = UIColor.white
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        //水平间隔
        layout.minimumInteritemSpacing = 0
        //垂直行间距
        layout.minimumLineSpacing = 0
        //整个view的宽度
        let collectionViewWidth = self.collectionView!.bounds.width
        //整个view横向除去间距后，剩余的像素个数
        let pxWidth = collectionViewWidth * UIScreen.main.scale - CGFloat(columnsNum - 1)
        //单元格宽度（像素）
        let itemWidthPx = CGFloat(Int(pxWidth / CGFloat(columnsNum)))
        //单元格宽度（点）
        let itemWidth = itemWidthPx / UIScreen.main.scale
        //设置单元格宽度和高度
        layout.itemSize = CGSize(width:itemWidth, height:self.collectionView!.bounds.height)
        //设置内边距
        layout.sectionInset = UIEdgeInsets(top: 0,left: 0,
                                           bottom: 0, right: 0)
    }
    
}

extension HZPageView:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as PageViewCell
        if let url = URL(string: self.dataSource[indexPath.row]){
            cell.iconImageView.kf.setImage(with: url,placeholder:UIImage(named: "占位图1.3X1.3"))
        }
        if self.selectorIndex == indexPath.row {
            cell.layer.borderWidth = 2
            cell.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        }else{
            cell.layer.borderWidth = 0
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectorIndex = indexPath.row
        self.collectionView.reloadData()
        if let url = URL(string:self.dataSource[indexPath.row]){
            self.mainImageView.kf.setImage(with: url,placeholder:UIImage(named: "占位图1.3X1.3"),options: [KingfisherOptionsInfoItem.transition(.fade(0.2))])

        }
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
