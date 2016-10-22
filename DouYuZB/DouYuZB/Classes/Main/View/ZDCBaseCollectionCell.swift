//
//  ZDCBaseCollectionCell.swift
//  DouYuZB
//
//  Created by allen on 16/10/22.
//  Copyright © 2016年 allen. All rights reserved.
//

import UIKit
import Kingfisher

class ZDCBaseCollectionCell: UICollectionViewCell {

    @IBOutlet weak var nickNameLabel: UILabel!
    
    var anchor : ZDCAnchorModel?{
        didSet{
            //1、校验模型是否有值
            guard let anchor = anchor else{ return }
            
            nickNameLabel.text = anchor.nickname
        }
    }

}
