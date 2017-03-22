//
//  XPageView.swift
//  XPageView
//
//  Created by sajiner on 2016/12/5.
//  Copyright © 2016年 sajiner. All rights reserved.
//

import UIKit

class XPageView: UIView {
    
    fileprivate var titles: [String]
    fileprivate var childVcs: [UIViewController]
    fileprivate var parentVc: UIViewController
    fileprivate var titleStyle: XTitleStyle
    // MARK: - 标题
    fileprivate lazy var titleView: XTitleView = {
        let titleView = XTitleView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.titleStyle.titleHeight), titles: self.titles, style: self.titleStyle)
        return titleView
    }()
    
    // MARK: - 内容
    fileprivate lazy var contentView: XContentView = {
        let contentView = XContentView(frame: CGRect(x: 0, y: self.titleView.frame.maxY, width: self.bounds.width, height: self.bounds.height - self.titleView.frame.maxY), childVcs: self.childVcs, parentVc: self.parentVc)
        return contentView
        
    }()
    

    init(frame: CGRect, titles: [String], childVcs: [UIViewController], parentVc: UIViewController, titleStyle: XTitleStyle) {
        self.titles = titles
        self.childVcs = childVcs
        self.parentVc = parentVc
        self.titleStyle = titleStyle
        
        super.init(frame: frame)
        
        addSubview(titleView)
        addSubview(contentView)
        titleView.delegate = contentView
        contentView.delegate = titleView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
