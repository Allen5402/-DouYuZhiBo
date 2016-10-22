//
//  NSDate-Extension.swift
//  DouYuZB
//
//  Created by allen on 16/10/22.
//  Copyright © 2016年 allen. All rights reserved.
//

import Foundation

extension NSDate{
    class func getCurrentTime() -> String{
        let nowDate = NSDate()
        let interval = Int(nowDate.timeIntervalSince1970)
        
        return "\(interval)"
    }
    
}
