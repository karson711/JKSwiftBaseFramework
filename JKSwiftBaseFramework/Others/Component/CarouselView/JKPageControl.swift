//
//  JKPageControl.swift
//  JKSwiftBaseFramework
//
//  Created by Kunge on 2018/8/9.
//  Copyright © 2018年 Kunge. All rights reserved.
//

import UIKit

class JKPageControl: UIPageControl {
    
    var pageSize: CGSize?
    var defaultImage: UIImage?
    var currentImage: UIImage?
    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
    
    override var currentPage: Int {
        didSet {
            for i in 0..<self.subviews.count {
                let dot: UIView = self.subviews[i]
                if self.pageSize == nil {
                    dot.frame = CGRect(x: dot.frame.origin.x, y: dot.frame.origin.y, width: 6, height: 6)
                }
                else {
                    dot.frame = CGRect(x: dot.frame.origin.x, y: dot.frame.origin.y, width: (self.pageSize?.width)!, height: (self.pageSize?.height)!)
                }
                
                if dot.subviews.count == 0 {
                    let view: UIImageView = UIImageView.init(frame: dot.bounds)
                    dot.addSubview(view)
                }
                
                let imageView: UIImageView = dot.subviews[0] as! UIImageView
                imageView.contentMode = UIViewContentMode.scaleAspectFit
                if i == currentPage && self.currentImage != nil {
                    imageView.image = self.currentImage
                }
                else if self.defaultImage != nil {
                    imageView.image = self.defaultImage
                }
            }
        }
    }
    
//    // initializer 默认是不会被继承的
//    init() {
//        super.init() // initialize super class first
//    }
//
//    // 重写方法
//    override func description() {
//        super.description()
//    }
}
