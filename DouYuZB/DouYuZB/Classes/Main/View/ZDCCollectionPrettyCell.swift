//
//  ZDCCollectionPrettyCell.swift
//  DouYuZB
//
//  Created by allen on 16/10/18.
//  Copyright © 2016年 allen. All rights reserved.
//

import UIKit
import Kingfisher

class ZDCCollectionPrettyCell: ZDCBaseCollectionCell {

    //MARK:- 模型属性
    
    @IBOutlet weak var onlineLabel: UILabel!
    @IBOutlet weak var defaultImageView: UIImageView!
    
    @IBOutlet weak var cityBtn: UIButton!
    
    //定义模型
    override var anchor : ZDCAnchorModel?{
        didSet{
            super.anchor = anchor
            
            //1、校验模型是否有值
            guard let anchor = anchor else{ return }
            
            //2、取出在线人数显示文字
            var onlineStr : String = ""
            if anchor.online >= 10000 {
                onlineStr = "\(Int( anchor.online / 10000))万在线"
            }else{
                onlineStr = "\(anchor.online)在线"
            }
            onlineLabel.text = onlineStr
            
            //3、所在城市
            cityBtn.setTitle(anchor.anchor_city, forState: .Normal)
            
            //4、封面图片
            guard let url = NSURL(string: anchor.vertical_src) else{ return }
            defaultImageView.kf_setImageWithURL(url, placeholderImage: UIImage(named: "live_cell_default_phone"), optionsInfo: nil, progressBlock: nil
                , completionHandler: nil)
        }
    }

}
