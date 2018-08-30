//
//  JKLifeViewController.swift
//  JKSwiftBaseFramework
//
//  Created by Kunge on 2018/8/8.
//  Copyright © 2018年 Kunge. All rights reserved.
//

import UIKit

class JKLifeViewController: JKBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        let imageV: UIImageView = UIImageView(frame: CGRect(x: 40, y: 50, width: 300, height: 150))
        imageV.contentMode = UIViewContentMode.scaleAspectFit
        self.view.addSubview(imageV)
        
        // 请求JSON数据
        //        JKHttpManager.manager.requestJSONData(target: JKAPIManager.login(account: "13688888888", password: "8Jk/wNL91omDMpBBJaaFfg=="), successClosure: { (json) in
        //            print(json)
        //        }) { (error) in
        //            print(error as Any)
        //        }
        
        // 下载文件
        JKHttpManager.manager.downloadFile(urlString: "http://public.idmei.cn/15312406214566.jpg", saveName: nil, downloadProgress: { (progress) in
            print("Download Progress: \(progress.fractionCompleted)")
        }, destinationURL: { (fileURL) in
            print("filePath: \(fileURL?.absoluteString ?? "")")
        }) { (response) in
            print("resonse: \(response)")
            if let data = response.result.value {
                let image = UIImage(data: data)
                imageV.image = image
            }
        }
        // http://song.paohaile.com/30854966.mp3
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
