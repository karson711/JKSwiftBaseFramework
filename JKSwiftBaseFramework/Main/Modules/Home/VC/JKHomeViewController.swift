//
//  JKHomeViewController.swift
//  JKSwiftBaseFramework
//
//  Created by Kunge on 2018/8/8.
//  Copyright © 2018年 Kunge. All rights reserved.
//

import UIKit

class JKHomeViewController: JKBaseViewController,JKCarouselViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        // 方式一：闭包方式初始化
        let carouselView: JKCarouselView = JKCarouselView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 240), configClosure: { (config) in
            config.changeMode = .ChangeModeFade
        }) { (index) in
            print(index)
        }
        
        // 方式二：协议方式初始化
        //        let carouselView: JKCarouselView = JKCarouselView.init(frame: CGRect(x: 0, y: 20, width: kScreenWidth, height: 240), configClosure: { (config) in
        //
        //        }, clickClosure: nil)
        //        carouselView.delegate = self
        
        self.view.addSubview(carouselView)
        
        carouselView.imagesArray = ["http://public.idmei.cn/152445585278734.jpg", "http://public.idmei.cn/152445590925818.jpg", "http://public.idmei.cn/152445593237244.jpg", "http://public.idmei.cn/152445594907287.jpg"]
    }
    
    func carouselView(_ carouselView: JKCarouselView, didClickedAtIndex index: NSInteger) {
        print(index)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
