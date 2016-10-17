//
//  ZDCHomeViewController.swift
//  DouYuZB
//
//  Created by allen on 16/10/14.
//  Copyright © 2016年 allen. All rights reserved.
//

import UIKit

private let kTitleViewH : CGFloat = 40

class ZDCHomeViewController: UIViewController {

    //MARK:懒加载属性
    private lazy var pageTitleView : ZDCPageTitleView = { [weak self] in
    
        let titleFrame = CGRect(x: 0, y: kStatusBarH + kNavigationBarH, width: kScreenW, height: kTitleViewH)
        let titles = ["推荐", "游戏", "娱乐", "趣玩"]
        let titleView = ZDCPageTitleView(frame: titleFrame, titles: titles)
        titleView.delegate = self
        return titleView
    }()
    
    private lazy var pageContentView : ZDCPageContentView = { [weak self] in
    
        //1、确定内容的frame
        let contentH = kScreenH - kStatusBarH - kNavigationBarH - kTitleViewH - kTabBarH
        let contentFrame = CGRect(x: 0, y: kStatusBarH + kNavigationBarH + kTitleViewH, width: kScreenW, height: contentH)
        
        //2、确定所有子控制器
        var childVcs = [UIViewController]()
        childVcs.append(ZDCRecommendViewController())
        for _ in 0..<3{
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor(r: CGFloat(arc4random_uniform(255)), g: CGFloat(arc4random_uniform(255)), b: CGFloat(arc4random_uniform(255)))
            childVcs.append(vc)
        }
        let contentView = ZDCPageContentView(frame: contentFrame, childVcs: childVcs, parentViewController: self)
        contentView.delegate = self
        return contentView
    }()
    
    //MARK:系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()

        //设置UI
        setupUI()
    }

}

//MARK:-设置UI界面
extension ZDCHomeViewController{

    private func setupUI(){
    
        //0、不需要调整UIScrollView的内边距
        automaticallyAdjustsScrollViewInsets = false
        
        //1、设置导航栏
        setupNavigationBar()
        
        //2、添加TitleView
        view.addSubview(pageTitleView)
        
        //3、添加ContentView
        view.addSubview(pageContentView)
        pageContentView.backgroundColor = UIColor .purpleColor()
    }
    
    private func setupNavigationBar(){
    
        //1、设置左侧item
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "logo", highImageName: "", size: CGSizeZero)
        
        //2、设置右侧item
        let size = CGSize(width: 40, height: 40)
        
        let historyItem = UIBarButtonItem(imageName: "image_my_history", highImageName: "Image_my_history_click", size: size)
        
        let searchItem = UIBarButtonItem(imageName: "btn_search", highImageName: "btn_search_clicked", size: size)
        
        let qrcodeItem = UIBarButtonItem(imageName: "Image_scan", highImageName: "Image_scan_click", size: size)
        
        navigationItem.rightBarButtonItems = [historyItem,searchItem,qrcodeItem]
    }
}

//MARK:- 遵守PageTitleViewDelegate协议
extension ZDCHomeViewController : PageTitleViewDelegate{

    func pageTitleView(titleView: ZDCPageTitleView, selectedIndex index: Int){
        pageContentView.setCurrentIndex(index)
    }
}

//MARK:- 遵守PageContentViewDelegate协议
extension ZDCHomeViewController : PageContentViewDelegate{

    func pageContentView(contentView: ZDCPageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageTitleView.setTitleWithProgress(progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}
