//
//  ZDCAnchorModel.swift
//  DouYuZB
//
//  Created by allen on 16/10/22.
//  Copyright © 2016年 allen. All rights reserved.
//

import UIKit

class ZDCAnchorModel: NSObject {

    ///房间id
    var room_id : Int = 0
    
    ///房间图片对应URLString
    var vertical_src : String = ""
    
    //判断是手机直播还是电脑直播
    //0:表示电脑直播 //1:表示手机直播
    var isVertical : Int = 0
    
    //房间名称
    var room_name : String = ""
    
    //主播昵称
    var nickname : String = ""
    
    //观看人数
    var online : Int = 0
    
    //所在城市
    var anchor_city : String = ""
    
    init(dict : [String : NSObject]) {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
}
