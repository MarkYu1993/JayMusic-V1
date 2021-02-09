//
//  TabBarViewController.swift
//  JayMusic
//
//  Created by ucom Apple S14 on 2021/2/8.
//  Copyright © 2021 Penny Huang. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.isTranslucent = false  //避免受默认的半透明色影响，关闭
        self.tabBar.tintColor = UIColor.yellow
        self.tabBar.barTintColor = UIColor.black
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
