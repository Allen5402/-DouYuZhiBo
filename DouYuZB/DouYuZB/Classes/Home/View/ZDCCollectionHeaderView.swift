//
//  ZDCCollectionHeaderView.swift
//  DouYuZB
//
//  Created by allen on 16/10/17.
//  Copyright © 2016年 allen. All rights reserved.
//

import UIKit

class ZDCCollectionHeaderView: UICollectionReusableView {

    //MARK:- 控件属性
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    //MARK:- 定义模型属性
    var group : ZDCAnchorGroup?{
        didSet{
            titleLable.text = group?.tag_name
            iconImageView.image = UIImage(named: group?.icon_name ?? "home_header_normal")
        }
    }
    
}
