//
//  MainViewController.swift
//  DouYuZB
//
//  Created by allen on 16/10/14.
//  Copyright © 2016年 allen. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        addChildVc("Home")
        addChildVc("Live")
        addChildVc("Follow")
        addChildVc("Profile")
        
    }

    private func addChildVc(storyName : String){
    
        //1、通过storyBoard获得控制器
        let childVC = UIStoryboard(name: storyName, bundle: nil).instantiateInitialViewController()!
        
        //2、将childVC添加子控制器
        addChildViewController(childVC)
    }
   

}
