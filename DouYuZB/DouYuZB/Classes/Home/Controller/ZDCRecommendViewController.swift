//
//  ZDCRecommendViewController.swift
//  DouYuZB
//
//  Created by allen on 16/10/17.
//  Copyright © 2016年 allen. All rights reserved.
//

import UIKit

private let kItemMargin : CGFloat = 10
private let kItemW = (kScreenW - 3 * kItemMargin) / 2
private let kNormalItemH = kItemW * 3 / 4
private let kPrettyItemH = kItemW * 4 / 3
private let kHeaderViewH : CGFloat = 50

private let kNormalCellID = "kNormalCellID"
private let kPrettyCellID = "kPrettyCellID"
private let kHeaderViewID = "kHeaderViewID"

class ZDCRecommendViewController: UIViewController {

    //MARK:- 懒加载属性
    private lazy var recommendViewModel: ZDCRecommendViewModel = ZDCRecommendViewModel()
    private lazy var collcetionView : UICollectionView = {
        //1、创建布局
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kItemW, height: kNormalItemH)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = kItemMargin
        layout.headerReferenceSize = CGSize(width: kScreenW, height: kHeaderViewH)
        layout.sectionInset = UIEdgeInsets(top: 0, left: kItemMargin, bottom: 0, right: kItemMargin)
        
        //创建UICollectionView
        let colletionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        colletionView.dataSource = self
        colletionView.delegate = self
        colletionView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        colletionView.backgroundColor = UIColor.whiteColor()
        
        colletionView.registerNib(UINib(nibName: "ZDCCollectionNormalCell", bundle: nil), forCellWithReuseIdentifier: kNormalCellID)
        colletionView.registerNib(UINib(nibName: "ZDCCollectionPrettyCell", bundle: nil), forCellWithReuseIdentifier: kPrettyCellID)
        colletionView.registerNib(UINib(nibName: "ZDCCollectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kHeaderViewID)
        
        return colletionView
    }()
    
    //MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置UI界面
        setupUI()
        
        //数据请求
        loadData()
    }

    

}

//MARK:- 设置UI界面内容
extension ZDCRecommendViewController{

    private func setupUI() {
    
        //1、将UICollectionView添加到控制的View中
        view.addSubview(collcetionView)
    }
}

//MARK:- 请求数据
extension ZDCRecommendViewController{

    private func loadData(){
        recommendViewModel.requestData { 
            self.collcetionView.reloadData()
        }
    }
}

//MARK:- 遵守UICollectionView数据源的协议
extension ZDCRecommendViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return recommendViewModel.anchorGroups.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let group = recommendViewModel.anchorGroups[section]
        
        return group.anchors.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        //1、取出模型对象
        let group = recommendViewModel.anchorGroups[indexPath.section]
        let anchor = group.anchors[indexPath.item]
        
        var cell : ZDCBaseCollectionCell
        
        //2、取出cell
        if indexPath.section == 1 {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(kPrettyCellID, forIndexPath: indexPath) as! ZDCCollectionPrettyCell
            
            cell.anchor = anchor

        }else{
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(kNormalCellID, forIndexPath: indexPath) as! ZDCCollectionNormalCell
            
            cell.anchor = anchor
            
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        //1、 取出setion的HeaderView
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: kHeaderViewID, forIndexPath: indexPath) as! ZDCCollectionHeaderView
        
        //2、取出模型
        headerView.group = recommendViewModel.anchorGroups[indexPath.section]
        
        return headerView
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if indexPath.section == 1 {
            return CGSize(width: kItemW, height: kPrettyItemH)
        }
        
            return CGSize(width: kItemW, height: kNormalItemH)
    }
}

