//
//  JKCarouselCollectionCell.swift
//  JKSwiftBaseFramework
//
//  Created by Kunge on 2018/8/9.
//  Copyright © 2018年 Kunge. All rights reserved.
//

import UIKit

class JKCarouselCollectionCell: UICollectionViewCell {
    
    var imageV: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageV = UIImageView.init(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        imageV.contentMode = UIViewContentMode.scaleToFill
        self.contentView.addSubview(imageV)
    }
    
//    lazy var imageView: UIImageView = {
//        let imageV: UIImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
//        imageV.contentMode = UIViewContentMode.scaleToFill
//        imageV.clipsToBounds = true
//        return imageV
//    }()
}
