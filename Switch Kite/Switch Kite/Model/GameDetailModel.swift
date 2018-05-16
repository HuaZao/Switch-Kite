//
//  GameDetailModel.swift
//  Switch Kite
//
//  Created by 神奇海螺 on 2018/5/14.
//  Copyright © 2018年 SQHL. All rights reserved.
//

import UIKit
import HandyJSON
class GameDetailModel: NSObject,HandyJSON{
    var appid: String = String()
    var brief: String = String()
    var category: [String] = [String]()
    var chineseVer: Int = 0
    var country: String = String()
    var demo: Bool = false
    var detail: String = String()
    var entity: Bool = false
    var icon: String = String()
    var pics: [String] = [String]()
    var playMode: String = String()
    var players: Int = 0
    var playersMin: Int = 0
    var price: CGFloat = 0.0
    var pubDate: String = String()
    var rate: Int = 0
    var size: String = String()
    var title: String = String()
    var titleZh: String = String()
    var videos: String = String()
    var prices: [GameDetailPricesModel] = [GameDetailPricesModel]()
    
    override required init() {
        
    }
    
}

class GameDetailPricesModel: NSObject,HandyJSON{
    
    var coinName: String = String()
    var country: String = String()
    var originPrice: String = String()
    var price: String = String()
    var cutoff: Int = 0

    override required init() {
        
    }
}

open class StringArrayTransform: TransformType {
    public typealias Object = [String]
    public typealias JSON = String
    
    public init() {}
    
    public func transformFromJSON(_ value: Any?) -> [String]? {
        if let string = value as? String{
            let object = string.components(separatedBy: ",")
            return object
        }
        return nil
    }
    
    public func transformToJSON(_ value: [String]?) -> String? {
        if let value = value{
            if let stringData = try? JSONSerialization.data(withJSONObject: value, options: .prettyPrinted),let string = String(data: stringData, encoding: String.Encoding.utf8){
                return string
            }
        }
        return nil
    }
    
}
