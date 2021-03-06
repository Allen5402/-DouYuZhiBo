//
//  ZDCPageTitleView.swift
//  DouYuZB
//
//  Created by allen on 16/10/15.
//  Copyright © 2016年 allen. All rights reserved.
//

import UIKit

//MARK: 定义协议
protocol PageTitleViewDelegate : class { //表示只能被类遵守 不被结构体等
    func pageTitleView(titleView : ZDCPageTitleView, selectedIndex index : Int)
}

//MARK: 定义常量
private let kScrollLineH : CGFloat = 2
private let kNormalColor: (CGFloat, CGFloat, CGFloat) = (85, 85, 85)
private let kSelectColor: (CGFloat, CGFloat, CGFloat) = (255, 128, 0)

//MARK: 定义PageTitleView类
class ZDCPageTitleView: UIView {

    //MARK: - 定义属性
    private var currentIndex: Int = 0
    private var titles: [String]
    weak var delegate : PageTitleViewDelegate?
    
    //MARK:懒加载属性
    private lazy var titleLabels : [UILabel] = [UILabel]()
    private lazy var scrollView : UIScrollView = {
    
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false //点击回到最上面
        scrollView.bounces = false
        return scrollView
    }()
    //底部滑块属性
    private lazy var scrollLine : UIView = {
    
        let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor.orangeColor()
        return scrollLine
    }()
    
    //MARK: 自定义构造函数
    init(frame: CGRect, titles : [String]) {
        self.titles = titles
        
        super.init(frame: frame)
        
        //设置UI界面
        setupUI()
    }
    
    //重写init frame 或者自定义构造函数需要实现这个方法
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ZDCPageTitleView{

    private func setupUI(){
    
        //1、添加UIScrollView
        addSubview(scrollView)
        scrollView.frame = bounds
        
        //2、添加title对应的label
        setupTitleLabel()
        
        //3、设置底线和滚动的滑块
        setupBottomMenuAndScrollLine()
    }
    
    private func setupTitleLabel(){
    
        //确定label的一些frame值
        let labelW : CGFloat = frame.width / CGFloat(titles.count)
        let labelH : CGFloat = frame.height - kScrollLineH
        let labelY : CGFloat = 0
        
        for (index, title) in titles.enumerate() {
            //1、创建UILabel
            let label = UILabel()
            
            //2、设置Label的属性
            label.text = title
            label.tag = index
            label.font = UIFont.systemFontOfSize(16.0)
            label.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            label.textAlignment = .Center
            
            //3、设置label的frame
            let labelX : CGFloat = labelW * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            
            //4、将label添加到scrollViewshang
            scrollView.addSubview(label)
            titleLabels.append(label)
            
            //5、给label添加手势
            label.userInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelClick(_:)))
            label.addGestureRecognizer(tapGes)
        }
    }
    
    private func setupBottomMenuAndScrollLine(){
    
        //1、添加底线
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.lightGrayColor()
        let lineH : CGFloat = 0.5
        bottomLine.frame = CGRect(x: 0, y: frame.height - lineH, width: frame.width, height: lineH)
        addSubview(bottomLine)
        
        //2、添加scrollLine
            //获取第一个Label
        guard let firstLabel = titleLabels.first else { return }
        firstLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        
            //设置scrollLine的属性
        scrollView.addSubview(scrollLine)
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - kScrollLineH, width: firstLabel.frame.width, height: kScrollLineH)
    }
}

//MARK:- 监听Label的点击
extension ZDCPageTitleView{
  
    @objc private func titleLabelClick(tapGes: UITapGestureRecognizer){
    
        //1、获取当前Label
        guard let currentLabel = tapGes.view as? UILabel else { return }
        
        //2、获取之前Label
        let oldLabel = titleLabels[currentIndex]
        
        //3、切换文字的颜色
        currentLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        oldLabel.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
        
        //4、保存最新Label的下标值
        currentIndex = currentLabel.tag
        
        //5、滚动条位置发生改变
        let scrollLineX = CGFloat(currentLabel.tag) * scrollLine.frame.width
        UIView.animateWithDuration(0.15) { 
            self.scrollLine.frame.origin.x = scrollLineX
        }
        
        //6、通知代理
        delegate?.pageTitleView(self, selectedIndex: currentIndex)
    }
}

//MRAK:- 对外暴露的方法
extension ZDCPageTitleView{

    func setTitleWithProgress(progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        //1、取出sourceLabel/targetLabel
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        //2、处理滑块的逻辑
        let moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveX = moveTotalX * progress
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + moveX
   
        //3、颜色的渐变
        //3.1 取出变化的范围
        let colorDelta = (kSelectColor.0 - kNormalColor.0, kSelectColor.1 - kNormalColor.1, kSelectColor.2 - kNormalColor.2)
        
        //3.2 变化的sourceLabel
        sourceLabel.textColor = UIColor(r: kSelectColor.0 - colorDelta.0 * progress, g: kSelectColor.1 - colorDelta.1 * progress, b: kSelectColor.2 - colorDelta.2 * progress)
        //3.2 变化targetLabel
        targetLabel.textColor = UIColor(r: kNormalColor.0 + colorDelta.0 * progress, g: kNormalColor.1 + colorDelta.1 * progress, b: kNormalColor.2 + colorDelta.2 * progress)
        
        //4、记录最新的index
        currentIndex = targetIndex
    }
}



