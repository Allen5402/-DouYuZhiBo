//
//  ZDCCollectionNormalCell.swift
//  DouYuZB
//
//  Created by allen on 16/10/17.
//  Copyright © 2016年 allen. All rights reserved.
//

import UIKit
import Kingfisher

class ZDCCollectionNormalCell: ZDCBaseCollectionCell {

    //MARK:- 模型属性
    @IBOutlet weak var onlineBtn: UIButton!
    
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var roomLabel: UILabel!
    
    
    override var anchor : ZDCAnchorModel?{
        didSet{
            super.anchor = anchor
            
            //1、取出在线人数显示文字
            var onlineStr : String = ""
            if anchor!.online >= 10000 {
                onlineStr = "\(Int( anchor!.online / 10000))万在线"
            }else{
                onlineStr = "\(anchor!.online)在线"
            }
            onlineBtn.setTitle(onlineStr, forState: .Normal)
            
            //2、房间
            roomLabel.text = anchor!.room_name
            
            //3、封面图片
            guard let url = NSURL(string: anchor!.vertical_src) else{ return }
            iconImageView.kf_setImageWithURL(url, placeholderImage: UIImage(named: "live_cell_default_phone"), optionsInfo: nil, progressBlock: nil
                , completionHandler: nil)
        }
    }

}
