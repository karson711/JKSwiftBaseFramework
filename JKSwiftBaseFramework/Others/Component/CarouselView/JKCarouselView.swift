//
//  JKCarouselView.swift
//  JKSwiftBaseFramework
//
//  Created by Kunge on 2018/8/9.
//  Copyright © 2018年 Kunge. All rights reserved.
//

import UIKit

@objc protocol JKCarouselViewDelegate {
    // 可选协议方法
    @objc optional func carouselView(_ carouselView: JKCarouselView, didClickedAtIndex index:NSInteger)
}

enum CarouselViewDirection {
    case DirectionLeft      // 轮播向左
    case DirectionRight     // 轮播向右
}

enum CarouselViewChangeMode {
    case ChangeModeNormal   // 普通左右移动
    case ChangeModeFade     // 淡入淡出
}

class JKCarouselConfig: NSObject {
    /**
     无限轮播间隔时间（默认：5秒）
     */
    var cycleTime: TimeInterval
    /**
     轮播的方向（默认：向左）
     */
    var scrollDirection: CarouselViewDirection
    /**
     切换模式（默认：普通左右移动）
     */
    var changeMode: CarouselViewChangeMode
    /**
     无限轮播（默认：yes）
     */
    var allowedCycle: Bool
    /**
     背景占位图
     */
    var placeholderImage: UIImage?
    /**
     选中pageCtrl的图片
     */
    var currentPageImage: UIImage?
    /**
     非选中pageCtrl的图片
     */
    var defaultPageImage: UIImage?
    
    override init() {
        self.cycleTime = 3
        self.scrollDirection = .DirectionLeft
        self.changeMode = .ChangeModeNormal
        self.allowedCycle = true
    }
}

typealias ConfigClosure = ((_ config: JKCarouselConfig) -> ())?
typealias ClickedClosure = ((_ index: NSInteger) -> ())?

class JKCarouselView: UIView,UICollectionViewDataSource,UICollectionViewDelegate {
    
    var delegate: JKCarouselViewDelegate?
    var carouselConfig: JKCarouselConfig!
    var clickedClosure: ClickedClosure
    var collectionView: UICollectionView!
    var pageCtrol: JKPageControl!
    var config: JKCarouselConfig!
    var timer: Timer!
    var newImgArray: NSMutableArray!
    var imagesArray: NSArray! {
        didSet {
            if imagesArray.count <= 0 {
                return;
            }
            else if imagesArray.count == 1 {
                self.newImgArray = NSMutableArray.init(array: imagesArray)
                self.collectionView.reloadData()
            }
            else {
                removeTimer()
                
                self.newImgArray = NSMutableArray.init(array: imagesArray)
                // 首尾分别插入一条数据
                self.newImgArray.add(imagesArray.firstObject!)
                self.newImgArray.insert(imagesArray.lastObject!, at: 0)
                
                self.collectionView.reloadData()
                
                // collectionView滚动到第二页的位置
                self.collectionView.contentOffset = CGPoint(x: self.collectionView.bounds.size.width, y: self.collectionView.contentOffset.y)
                
                // 设置pageCtrol
                let pageSize = self.pageCtrol.size(forNumberOfPages: imagesArray.count)
                self.pageCtrol.frame = CGRect(x: (self.frame.size.width - pageSize.width) / 2.0, y: self.frame.size.height - pageSize.height, width: pageSize.width, height: pageSize.height)
                self.pageCtrol.numberOfPages = imagesArray.count
                self.pageCtrol.currentPage = 0
                
                if config.allowedCycle {
                    addTimer()
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, configClosure: ConfigClosure, clickClosure: ClickedClosure) {
        super.init(frame: frame)
        
        config = JKCarouselConfig.init()
        if configClosure != nil {
            configClosure?(config)
        }
        
        self.carouselConfig = config
        self.clickedClosure = clickClosure
        
        setupUI()
    }
    
    /// 初始化UI
    func setupUI() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.frame.size.width, height: self.frame.size.height)
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        self.collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height), collectionViewLayout: layout)
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.isPagingEnabled = true
        self.collectionView.register(JKCarouselCollectionCell.self, forCellWithReuseIdentifier: "CarouselCell")
        self.addSubview(self.collectionView)
        
        self.pageCtrol = JKPageControl()
        if config.currentPageImage != nil {
            self.pageCtrol.currentImage = config.currentPageImage
        }
        else {
            self.pageCtrol.currentPageIndicatorTintColor = UIColor.red
        }
        if config.defaultPageImage != nil {
            self.pageCtrol.defaultImage = config.defaultPageImage
        }
        else {
            self.pageCtrol.pageIndicatorTintColor = UIColor.white
        }
        self.pageCtrol.hidesForSinglePage = true
        self.addSubview(self.pageCtrol)
    }
    
    /// 添加定时器
    func addTimer() {
        timer = Timer.scheduledTimer(timeInterval: config.cycleTime, target: self, selector: #selector(nextPage), userInfo: nil, repeats: true)
    }
    
    /// 移除定时器
    func removeTimer() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }
    
    /// 开启定时器
    func startTimer() {
        if self.newImgArray.count > 1 {
            self.collectionView .setContentOffset(CGPoint(x: self.collectionView.bounds.size.width, y: self.collectionView.contentOffset.y), animated: false)
            timer.fire()
        }
    }
    
    /// 暂停定时器
    func stopTimer() {
        if self.newImgArray.count > 1 {
            timer.fireDate = Date.distantFuture
        }
    }
    
    @objc func nextPage() {
        if self.collectionView.isDragging {
            return;
        }
        
        if config.changeMode == .ChangeModeNormal {
            let targetX = self.collectionView.contentOffset.x + self.collectionView.bounds.size.width
            self.collectionView .setContentOffset(CGPoint(x: targetX, y: self.collectionView.contentOffset.y), animated: true)
        }
        else if config.changeMode == .ChangeModeFade {
            let animation = CATransition.init()
            animation.duration = 0.7
            animation.type = kCATransitionFade
            animation.subtype = kCATransitionFromLeft
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            self.collectionView.layer .add(animation, forKey: "animation")
            
            let targetX = self.collectionView.contentOffset.x + self.collectionView.bounds.size.width
            self.collectionView .setContentOffset(CGPoint(x: targetX, y: self.collectionView.contentOffset.y), animated: false)
        }
    }
    
    func adjustOffset() {
        let offsetX = self.collectionView.contentOffset.x
        let page = Int(offsetX / self.collectionView.bounds.size.width)
        
        // 滚动到最左边时，自动滚动到倒数第二个
        if offsetX <= 0 {
            let x = self.collectionView.bounds.size.width * CGFloat(self.newImgArray.count - 2)
            self.collectionView.contentOffset = CGPoint(x: x, y: self.collectionView.contentOffset.y)
            self.pageCtrol.currentPage = self.newImgArray.count - 3
        }
            // 滚动到最右边时，自动滚动到第二个
        else if page == (self.newImgArray.count - 1) {
            self.collectionView.contentOffset = CGPoint(x: self.collectionView.bounds.size.width, y: self.collectionView.contentOffset.y)
            self.pageCtrol.currentPage = 0
        }
        else {
            self.pageCtrol.currentPage = page - 1
        }
    }
    
    deinit {
        timer.invalidate()
        timer = nil
    }
    
    
    // MARK: - scrollView delegate
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addTimer()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        adjustOffset()
        
        // 拖拽动作后间隔cycleTime后继续轮播
        timer.fireDate = NSDate(timeIntervalSinceNow: config.cycleTime) as Date
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        adjustOffset()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        adjustOffset()
    }
    
    
    // MARK: - collectionView delegate
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newImgArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselCell", for: indexPath) as! JKCarouselCollectionCell
        
        cell.imageV.kf.setImage(with: URL(string: newImgArray[indexPath.row] as! String), placeholder: config.placeholderImage, options: nil, progressBlock: nil) { (image, error, nil, imageURL) in
            // 下载完成后进行的操作
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.newImgArray.count == 1 {
            if self.clickedClosure != nil {
                self.clickedClosure?(indexPath.row)
            }
            
            delegate?.carouselView!(self, didClickedAtIndex: indexPath.row)
        }
        else {
            if self.clickedClosure != nil {
                self.clickedClosure?(indexPath.row - 1)
            }
            
            delegate?.carouselView!(self, didClickedAtIndex: indexPath.row - 1)
        }
    }
}
