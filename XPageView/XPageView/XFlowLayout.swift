//
//  XFlowLayout.swift
//  XPageView
//
//  Created by sajiner on 2016/12/5.
//  Copyright © 2016年 sajiner. All rights reserved.
//

import UIKit

class XFlowLayout: UICollectionViewFlowLayout {

    override func prepare() {
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = .horizontal
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.bounces = false
        
        guard let collectionView = collectionView else {
            fatalError("collectionView还未创建")
        }
        itemSize = CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
}
