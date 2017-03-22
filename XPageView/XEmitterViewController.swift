//
//  XEmitterViewController.swift
//  XPageView
//
//  Created by sajiner on 2016/12/14.
//  Copyright © 2016年 sajiner. All rights reserved.
//

import UIKit

private let kEmoticonCell = "kEmoticonCell"

class XEmitterViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        let pageFrame = CGRect(x: 0, y: 100, width: view.bounds.width, height: 300)
        
        let titles = ["土豪", "热门", "专属", "常见",]
        let style = XTitleStyle()
        style.isShowBotomLine = true
    
        let layout = XPageCollectionFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.cols = 4
        layout.rows = 2
        
        let pageCollectionView = XPageCollectionView(frame: pageFrame, titles: titles, titleStyle: style, isTitleInTop: true, layout: layout)
        pageCollectionView.backgroundColor = UIColor.gray
        
        pageCollectionView.dataSource = self
        pageCollectionView.register(cellClass: UICollectionViewCell.self, identifier: kEmoticonCell)
        
        view.addSubview(pageCollectionView)
    }
    
}


extension XEmitterViewController : XPageCollectionViewDataSource {
    
    func numberOfSections(in pageCollectionView: XPageCollectionView) -> Int {
        return 4
    }
    
    
    
    func pageCollectionView(_ collectionView: XPageCollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return 20
        } else {
            return 14
        }
    }
    
    func pageCollectionView(_ collectionView: UICollectionView, pageCollectionView: XPageCollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kEmoticonCell, for: indexPath)
        
        cell.backgroundColor = UIColor.getRandomColor()
        
        return cell
    }
}

