//
//  XContentView.swift
//  XPageView
//
//  Created by sajiner on 2016/12/5.
//  Copyright © 2016年 sajiner. All rights reserved.
//

import UIKit

//MARK: - 设置协议
protocol XContentViewDelegate: class {
    func contentView(_ contentView: XContentView, targetIndex: Int)
    func contentView(_ contentView: XContentView, targetIndex: Int, progress: CGFloat)
}

fileprivate let kContentViewCell = "kContentViewCell"
class XContentView: UIView {

    fileprivate var childVcs: [UIViewController]
    fileprivate var parentVc: UIViewController
    weak var delegate: XContentViewDelegate?
    fileprivate var startOffsetX: CGFloat = 0
    fileprivate var isForbidScroll = false
    
   fileprivate lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: XFlowLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.scrollsToTop = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kContentViewCell)
        return collectionView
    }()
    
    init(frame: CGRect, childVcs: [UIViewController], parentVc: UIViewController) {
        self.childVcs = childVcs
        self.parentVc = parentVc
        
        super.init(frame: frame)
        addSubview(collectionView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UICollectionViewDataSource
extension XContentView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kContentViewCell, for: indexPath)
        
        for subView in cell.contentView.subviews {
            subView.removeFromSuperview()
        }
        
        let childVc = childVcs[indexPath.row]
        childVc.view.frame = cell.bounds
        cell.contentView.addSubview(childVc.view)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension XContentView: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        contentEndScoll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            contentEndScoll()
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidScroll = false
        startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 判断和开始时的偏移量是否一致
        guard startOffsetX != scrollView.contentOffset.x, !isForbidScroll else {
            return
        }
        // 定义progress 和 targetIndex
        var progress: CGFloat = 0
        var targetIndex = 0
        
        // 给progress 和 targetIndex 赋值
        let currentIndex = Int(startOffsetX / scrollView.bounds.width)
        if startOffsetX > scrollView.contentOffset.x { // 右滑
            targetIndex = currentIndex - 1
            if targetIndex < 0 {
                targetIndex = 0
            }
            progress = (startOffsetX - scrollView.contentOffset.x) / scrollView.bounds.width
        } else {
            targetIndex = currentIndex + 1
            if targetIndex > childVcs.count - 1 {
                targetIndex = childVcs.count - 1
            }
            progress = (scrollView.contentOffset.x - startOffsetX) / scrollView.bounds.width
        }
        // 通知代理
        delegate?.contentView(self, targetIndex: targetIndex, progress: progress)
    }
    
    private func contentEndScoll() {
        // 判断是否是禁止状态
        guard !isForbidScroll else {
            return
        }
        let currentIndex = Int(collectionView.contentOffset.x / collectionView.bounds.width)
        delegate?.contentView(self, targetIndex: currentIndex)
    }
}

// MARK: - XTitleViewDelegate
extension XContentView: XTitleViewDelegate {
    func titleView(_ titleView: XTitleView, targetIndex: Int) {
        isForbidScroll = true
        let indexPath = IndexPath(item: targetIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    }
}
