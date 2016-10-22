//
//  ZDCRecommendViewModel.swift
//  DouYuZB
//
//  Created by allen on 16/10/22.
//  Copyright © 2016年 allen. All rights reserved.
//

import UIKit

class ZDCRecommendViewModel {

    //MARK:- 懒加载属性
    lazy var anchorGroups : [ZDCAnchorGroup] = [ZDCAnchorGroup]()
    private lazy var bigDataGroup : ZDCAnchorGroup = ZDCAnchorGroup()
    private lazy var prettGroup : ZDCAnchorGroup = ZDCAnchorGroup()
}

//MARK:- 发送网络请求
extension ZDCRecommendViewModel{

    func requestData(finishCallback: () -> ()){
        
        //1、定义参数
        let parameters = ["limit": "4", "offset": "0", "time": NSDate.getCurrentTime()]
        
        //2、创建线程组
        let dgroup = dispatch_group_create()
        
        //3、请求第一部分推荐数据
        dispatch_group_enter(dgroup)
        NetworkTools.requestData(.GET, URLString: "http://capi.douyucdn.cn/api/v1/getbigDataRoom", parameters: ["time": NSDate.getCurrentTime()]) { (result) in
            //1、将result转成字典
            guard let resultDic = result as? [String: NSObject] else{ return }
            
            //2、根据data的key获取数组
            guard let dataArray = resultDic["data"] as? [[String: NSObject]] else{ return }
            
            //3、遍历数组，获取字典，并将字典转成模型
            //3.1 设置组的属性
            self.bigDataGroup.tag_name = "热门"
            self.bigDataGroup.icon_name = "home_header_hot"
            
            //3.2 获取主播数据
            for dict in dataArray{
                let anchor = ZDCAnchorModel(dict : dict)
                self.bigDataGroup.anchors.append(anchor)
            }
            
            //3.3 离开组
            dispatch_group_leave(dgroup)
            print("请求到0")
        }
        
        
        //4、请求第二部分推荐数据
        dispatch_group_enter(dgroup)
        NetworkTools.requestData(.GET, URLString: "http://capi.douyucdn.cn/api/v1/getVerticalRoom", parameters: parameters) { (result) in
            //1、将result转成字典
            guard let resultDic = result as? [String: NSObject] else{ return }
            
            //2、根据data的key获取数组
            guard let dataArray = resultDic["data"] as? [[String: NSObject]] else{ return }
            
            //3、遍历数组，获取字典，并将字典转成模型
            //3.1 设置组的属性
            self.prettGroup.tag_name = "颜值"
            self.prettGroup.icon_name = "home_header_phone"
            
            //3.2 获取主播数据
            for dict in dataArray{
                let anchor = ZDCAnchorModel(dict : dict)
                self.prettGroup.anchors.append(anchor)
            }
            
            //3.3 离开组
            dispatch_group_leave(dgroup)
            print("请求道1")
        }
        
        //5、请求2-12部分的游戏数据
        //http://capi.douyucdn.cn/api/v1/getHotCate?limit=4&offset=0&time=1474252024
        dispatch_group_enter(dgroup)
        NetworkTools.requestData(.GET, URLString: "http://capi.douyucdn.cn/api/v1/getHotCate", parameters: parameters) { (result) in
            //1、将result转成字典
            guard let resultDic = result as? [String: NSObject] else{ return }
            
            //2、根据data的key获取数组
            guard let dataArray = resultDic["data"] as? [[String: NSObject]] else{ return }
            
            //3、遍历数组，获取字典，并将字典转成模型
            for dic in dataArray{
                let group = ZDCAnchorGroup(dict: dic)
                self.anchorGroups.append(group)
            }
            
            //4.离开组
            dispatch_group_leave(dgroup)
            print("请求到2-12")
        }
        
        //6. 所有的数据都请求到
        dispatch_group_notify(dgroup, dispatch_get_main_queue()) {
            //对三个组排序
            self.anchorGroups.insert(self.prettGroup, atIndex: 0)
            self.anchorGroups.insert(self.bigDataGroup, atIndex: 0)
            
            finishCallback()
        }
    }
}
