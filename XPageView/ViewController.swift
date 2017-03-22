//
//  ViewController.swift
//  XPageView
//
//  Created by sajiner on 2016/12/5.
//  Copyright © 2016年 sajiner. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    fileprivate var titleStyle = XTitleStyle()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let titles = ["兴趣", "颜值", "才女", "御姐风范"]
        let titles = ["兴趣", "颜值", "才女", "御姐风范", "颜值", "才女", "御姐风范", "颜值", "才女", "御姐风范", "颜值", "才女", "御姐风范"]
        for i in titles.reversed() {
            print(i)
        }
        titleStyle.isScroll = true
        titleStyle.titleFont = 16
        titleStyle.isShowBotomLine = true
        titleStyle.bottomLineHeight = 3
        
        var childVcs = [UIViewController]()
        
        for _ in 0..<titles.count {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.getRandomColor()
            childVcs.append(vc)
        }
        
        let frame = CGRect(x: 0, y: 64, width: self.view.bounds.width, height: self.view.bounds.height - 64)
        let pageView = XPageView(frame: frame, titles: titles, childVcs: childVcs, parentVc: self, titleStyle: titleStyle);
        view.addSubview(pageView)
        automaticallyAdjustsScrollViewInsets = false
    }

}

