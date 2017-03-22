//
//  XNavigationController.swift
//  XPageView
//
//  Created by sajiner on 2016/12/12.
//  Copyright © 2016年 sajiner. All rights reserved.
//

import UIKit

class XNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: true)
        
        
//        var count: UInt32 = 0
//        let propoties = class_copyIvarList(UINavigationController.self, &count)
//       
//        for i in 0..<Int(count) {
//            guard let list = propoties else {
//                return
//            }
//            let cName = property_getName(list[i])
//            let name = String(utf8String: cName!)
//            print(name)
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
    }

}
