//
//  ZDCPageContentView.swift
//  DouYuZB
//
//  Created by allen on 16/10/15.
//  Copyright © 2016年 allen. All rights reserved.
//

import UIKit

protocol PageContentViewDelegate : class {
    func pageContentView(contentView : ZDCPageContentView, progress : CGFloat, sourceIndex : Int, targetIndex : Int)
}

private let ContentCellID = "ContentCellID"

class ZDCPageContentView: UIView {

    //MARK: - 定义属性
    private var childVcs : [UIViewController]
    private weak var parentViewController: UIViewController?//默认强引用，防止HomeViewController的循环引用 弱引用修饰可选类型
    private var startOffsetX: CGFloat = 0
    private var isForbidScrollDelegate : Bool = false
    weak var delegate : PageContentViewDelegate?
    
    //MARK: - 懒加载属性
    private lazy var collecitonView: UICollectionView = { [weak self] in //闭包的循环引用转成weak
        //1、创建layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!//需要强制解包，self肯定有值
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .Horizontal
        
        //2、创建UICollectionView
        let colletionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        colletionView.showsHorizontalScrollIndicator = false
        colletionView.pagingEnabled = true
        colletionView.bounces = false
        colletionView.dataSource = self
        colletionView.delegate = self
        colletionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: ContentCellID)
        
        return colletionView
    }()
    
    //MARK: - 自定义构造函数
    init(frame: CGRect, childVcs: [UIViewController], parentViewController: UIViewController?) { //传可选
        self.childVcs = childVcs
        self.parentViewController = parentViewController
        
        super.init(frame: frame)
        
        //设置UI
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//MARK: 设计UI
extension ZDCPageContentView{

    private func setupUI(){
        //1、将所有子控制器添加到副控制器中
        for childVc in childVcs {
            parentViewController?.addChildViewController(childVc)//可选链
        }
        
        //2、添加UIColletionView，用于在Cell中存放控制器的View
        addSubview(collecitonView)
        collecitonView.frame = bounds
    }
}

//MARK: 遵守UICollectionViewDataSource
extension ZDCPageContentView : UICollectionViewDataSource{

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //1、创建cell
        let cell = collecitonView.dequeueReusableCellWithReuseIdentifier(ContentCellID, forIndexPath: indexPath)
        
        //2、给cell设置内容
        for view in cell.contentView.subviews {//可能一直添加
            view.removeFromSuperview()
        }
        
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        
        return cell
    }
}

//MARK: 遵守UICollectionViewDelegate
extension ZDCPageContentView: UICollectionViewDelegate{

    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
        isForbidScrollDelegate = false
        
        startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {//滚动方法
        //0.判断是否是点击事件
        if isForbidScrollDelegate { return }
        
         //1、获取需要的数据
        var progress : CGFloat = 0
        var sourceIndex : Int = 0
        var targetIndex : Int = 0
        
        //2、判断是左滑还是右滑
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        if currentOffsetX > startOffsetX {//左滑
            //1、计算progress
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)//取整函数
            
            //2、计算sourceIndex
            sourceIndex = Int(currentOffsetX / scrollViewW)
            
            //3、计算targetIndex
            targetIndex = sourceIndex + 1
            if targetIndex > childVcs.count {
                targetIndex = childVcs.count - 1
            }
            
            //4、如果完全划过去
            if currentOffsetX - startOffsetX == scrollViewW {
                progress = 1
                targetIndex = sourceIndex
            }
        }else{//右滑
            //1、计算progress
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            
            //2、计算targetIndex
            targetIndex = Int(currentOffsetX / scrollViewW)
            
            //3、计算sourceIndex
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVcs.count {
                sourceIndex = childVcs.count - 1
            }
        }
        
        //3、将progress/sourceIndex/targetIndex传递给titleView 通知代理
        delegate?.pageContentView(self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}

//MARK: - 对外暴露的方法
extension ZDCPageContentView{

    func setCurrentIndex(currentIndex : Int){
    
        //1、记录需要进行执行代理方法
        isForbidScrollDelegate = true
        
        //2、滚动正确的位置
        let offSetX = CGFloat(currentIndex) * collecitonView.frame.width
        collecitonView.setContentOffset(CGPoint(x: offSetX, y: 0), animated: false)
    }
}
