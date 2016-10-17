//
//  UIBarButtonItem-Extention.swift
//  DouYuZB
//
//  Created by allen on 16/10/14.
//  Copyright © 2016年 allen. All rights reserved.
//

import UIKit

extension UIBarButtonItem{

    /*
     //抽取类函数
    class func createItem(imageName: String, highImageName: String, size:CGSize) -> UIBarButtonItem{
        
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), forState: .Normal)
        btn.setImage(UIImage(named: highImageName), forState: .Highlighted)
        btn.frame = CGRect(origin: CGPointZero, size: size)
        
        return UIBarButtonItem(customView: btn)
    }
   */
    
    //同上，swift推荐-便利构造函数：1、convenience开头 2、在构造函数中必须明确调用一个设计构造函数(self)
    convenience init(imageName : String, highImageName : String = "", size : CGSize = CGSizeZero) {
       
        let btn = UIButton()
        
        btn.setImage(UIImage(named: imageName), forState: .Normal)
        
        if highImageName != "" {
            btn.setImage(UIImage(named: highImageName), forState: .Highlighted)
        }
        
        if size == CGSizeZero {
            btn.sizeToFit()
        }else{
            btn.frame = CGRect(origin: CGPointZero, size: size)
        }
        
        self.init(customView: btn)
    }
}

