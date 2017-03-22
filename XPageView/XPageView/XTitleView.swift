//
//  XTitleView.swift
//  XPageView
//
//  Created by sajiner on 2016/12/5.
//  Copyright © 2016年 sajiner. All rights reserved.
//

import UIKit

protocol XTitleViewDelegate: class {
    func titleView(_ titleView: XTitleView, targetIndex: Int)
}

class XTitleView: UIView {
    
    weak var delegate: XTitleViewDelegate?
    
    fileprivate var titles: [String]
    fileprivate var style: XTitleStyle
    fileprivate var titleLabels = [UILabel]()
    fileprivate var currentIndex = 0
    
    fileprivate lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: self.bounds)
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    fileprivate lazy var botomLine: UIView = {
        let botomLine = UIView()
        botomLine.backgroundColor = self.style.selColor
        botomLine.frame.size.height = self.style.bottomLineHeight
        botomLine.frame.origin.y = self.style.titleHeight - self.style.bottomLineHeight
        return botomLine
    }()
    
    init(frame: CGRect, titles: [String], style: XTitleStyle) {
        self.titles = titles
        self.style = style
        super.init(frame: frame)
        addSubview(scrollView)
        // 添加所有的label
        setupTitleLabels()
        // 设置labelFrame
        setupTitleFrames()
        
        if style.isShowBotomLine {
            scrollView.addSubview(botomLine)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 创建UI
extension XTitleView {
    
    fileprivate func setupTitleLabels() {
        // 添加所有的label
        for (i, title) in titles.enumerated() {
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.tag = i
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont.systemFont(ofSize: style.titleFont)
            titleLabel.textColor = i == 0 ? style.selColor : style.norColor
            scrollView.addSubview(titleLabel)
            titleLabels.append(titleLabel)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(_:)))
            titleLabel.addGestureRecognizer(tap)
            titleLabel.isUserInteractionEnabled = true
        }
    }
    
    fileprivate func setupTitleFrames() {
        let y: CGFloat = 0
        let h = style.titleHeight
        var x: CGFloat = 0
        var w: CGFloat = 0
        
        let count = titleLabels.count
        
        for (i, label) in titleLabels.enumerated() {
            if style.isScroll { // 可以滚动
                w = (titles[i] as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: label.font], context: nil).width
                x = i == 0 ? style.margin * 0.5 : (titleLabels[i - 1].frame.maxX + style.margin)
                if style.isShowBotomLine && i == 0 {
                    botomLine.frame.origin.x = style.margin * 0.5
                    botomLine.frame.size.width = w
                }
            } else {  // 不可以滚动
                w = bounds.width / CGFloat(count)
                x = w * CGFloat(i)
                if style.isShowBotomLine && i == 0 {
                    botomLine.frame.origin.x = 0
                    botomLine.frame.size.width = w
                }
            }
            label.frame = CGRect(x: x, y: y, width: w, height: h)
        }
        scrollView.contentSize = style.isScroll ? CGSize(width: (titleLabels.last?.frame.maxX)! + style.margin * 0.5, height: 0) : CGSize.zero
    }
}

// MARK: - 点击事件
extension XTitleView {
    @objc fileprivate func titleLabelClick(_ tap: UITapGestureRecognizer) {
        let targetLabel = (tap.view as! UILabel)
        adjuestTitleLabels(targetIndex: targetLabel.tag)
        
        if style.isShowBotomLine {
            UIView.animate(withDuration: 0.25, animations: {
                self.botomLine.frame.origin.x = targetLabel.frame.origin.x
                self.botomLine.frame.size.width = targetLabel.frame.width
            })
        }
        // 让内容跟着滚动
        delegate?.titleView(self, targetIndex: targetLabel.tag)
    }
}

 // MARK: - 点击事件
extension XTitleView: XContentViewDelegate {
    func contentView(_ contentView: XContentView, targetIndex: Int) {
        adjuestTitleLabels(targetIndex: targetIndex)
    }
    
    func contentView(_ contentView: XContentView, targetIndex: Int, progress: CGFloat) {
        // 获取原label和目标label
        let targetLabel = titleLabels[targetIndex]
        let sourceLabel = titleLabels[currentIndex]
        // 颜色渐变
        let deltaRGB = UIColor.getRGBDelta(style.selColor, style.norColor)
        let selRGB = style.selColor.getRGB()
        let norRGB = style.norColor.getRGB()
        targetLabel.textColor = UIColor(norRGB.0 + deltaRGB.0 * progress, norRGB.1 + deltaRGB.1 * progress, norRGB.2 + deltaRGB.2 * progress)
        sourceLabel.textColor = UIColor(selRGB.0 - deltaRGB.0 * progress, selRGB.1 - deltaRGB.1 * progress, selRGB.2 - deltaRGB.2 * progress)
        
        // botomLine
        if style.isShowBotomLine {
            let deltaX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
            let deltaW = targetLabel.frame.width - sourceLabel.frame.width
            botomLine.frame.origin.x = sourceLabel.frame.origin.x + deltaX * progress
            botomLine.frame.size.width = sourceLabel.frame.width + deltaW * progress
        }
    }
}

 // MARK: - 对外暴露的方法
extension XTitleView {
    func setTitleWithProgress(_ progress : CGFloat, sourceIndex : Int, targetIndex : Int) {
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        let deltaRGB = UIColor.getRGBDelta(style.selColor, style.norColor)
        let selRGB = style.selColor.getRGB()
        let norRGB = style.norColor.getRGB()
        targetLabel.textColor = UIColor(norRGB.0 + deltaRGB.0 * progress, norRGB.1 + deltaRGB.1 * progress, norRGB.2 + deltaRGB.2 * progress)
        sourceLabel.textColor = UIColor(selRGB.0 - deltaRGB.0 * progress, selRGB.1 - deltaRGB.1 * progress, selRGB.2 - deltaRGB.2 * progress)
        
        // botomLine
        if style.isShowBotomLine {
            let deltaX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
            let deltaW = targetLabel.frame.width - sourceLabel.frame.width
            botomLine.frame.origin.x = sourceLabel.frame.origin.x + deltaX * progress
            botomLine.frame.size.width = sourceLabel.frame.width + deltaW * progress
        }
        currentIndex = targetIndex
    }
}

 // MARK: - 私有方法
extension XTitleView {
   fileprivate func adjuestTitleLabels(targetIndex: Int) {
        // 获取原label和目标label
        let sourceLabel = titleLabels[currentIndex]
        let targetLabel = titleLabels[targetIndex]
        // 设置颜色
        sourceLabel.textColor = style.norColor
        targetLabel.textColor = style.selColor
    
        if style.isScroll {
            // 让targetLabel滚动到中间位置
            var offsetX: CGFloat =  targetLabel.center.x - scrollView.bounds.width * 0.5
            if offsetX < 0 {
                offsetX = 0
            } else if offsetX > scrollView.contentSize.width - scrollView.bounds.width {
                offsetX = scrollView.contentSize.width - scrollView.bounds.width
            }
            scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        }
        // 设置当前索引
        currentIndex = targetIndex
    }
}
