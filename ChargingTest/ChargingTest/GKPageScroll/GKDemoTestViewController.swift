//
//  GKDemoTestViewController.swift
//  ChargingTest
//
//  Created by Rzk on 2022/2/22.
//

import UIKit
import JXSegmentedView
import GKPageScrollView

let ADAPTATIONRATIO = screenWidth / 750.0

class GKDemoTestViewController: UIViewController {
    
    let headerViewHeight: CGFloat = 300.0
    let categroyHeight: CGFloat = 45.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        view.addSubview(pageScrollView)
        pageScrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        
        pageScrollView.reloadData()
    }
    
    // MARK: - event
    @objc func btnClick(btn: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - setter
    var model: Model? {
        didSet {
            if let model = model {
                self.titleDataSource.titles = model.data.map( { $0.name } )
                self.titleDataSource.reloadData(selectedIndex: 0)
            }
        }
    }
    
    // MARK: - lazy
    lazy var pageScrollView: GKPageScrollView = {
        let p = GKPageScrollView(delegate: self)
        p.ceilPointHeight = statusBarHeight
        return p
    }()
    
    lazy var headerView: UIView = {
        let imgView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: headerViewHeight))
        imgView.backgroundColor = UIColor.xnRandomColor()
        
        let b = UIButton()
        imgView.addSubview(b)
        b.setImage(UIImage(named: "ic_close"), for: .normal)
        b.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        b.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(statusBarHeight + 15)
            make.leading.equalToSuperview().offset(25)
            make.width.height.equalTo(40)
        }
        
        return imgView
    }()
    
    lazy var pageView: UIView = {
        let pageView = UIView()
        pageView.addSubview(self.segmentedView)
        pageView.addSubview(self.contentScrollView)
        return pageView
    }()
    
    lazy var childVCs: [GKDemoTestChildView] = {
        var childVCs = [GKDemoTestChildView]()
        
        if let model = model {
            for (index, datum) in model.data.enumerated() {
                let child = GKDemoTestChildView()
                child.model = datum
                childVCs.append(child)
            }
        }
        
        return childVCs
    }()
    
    lazy var titleDataSource: JXSegmentedTitleDataSource  = {
        let t = JXSegmentedTitleDataSource()
        t.titleNormalColor = UIColor.gray
        t.titleSelectedColor = UIColor.red
        t.titleNormalFont = UIFont.systemFont(ofSize: 15.0)
        t.titleSelectedFont = UIFont.systemFont(ofSize: 15.0)
//        t.reloadData(selectedIndex: 0)
        return t
    }()
    
    lazy var segmentedView: JXSegmentedView = {
        var segmentedView = JXSegmentedView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: categroyHeight))
        segmentedView.delegate = self
        segmentedView.dataSource = titleDataSource
        
        let lineView = JXSegmentedIndicatorLineView()
        lineView.lineStyle = .normal
        lineView.indicatorHeight = ADAPTATIONRATIO * 4.0
        lineView.verticalOffset = ADAPTATIONRATIO * 2.0
        segmentedView.indicators = [lineView]
        
        segmentedView.contentScrollView = self.contentScrollView
        
        let btmLineView = UIView()
        btmLineView.backgroundColor = UIColor.xnRandomColor()
        segmentedView.addSubview(btmLineView)
        btmLineView.snp.makeConstraints({ (make) in
            make.left.right.bottom.equalTo(segmentedView)
            make.height.equalTo(ADAPTATIONRATIO * 2.0)
        })
        
        return segmentedView
    }()
    
    lazy var contentScrollView: UIScrollView = {
        let scrollW = screenWidth
        let scrollH = screenHeight - statusBarHeight - categroyHeight - (UIWindow.xnKeyWindow()?.safeAreaInsets.bottom ?? 0)
        
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: categroyHeight, width: scrollW, height: scrollH))
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        
        for (index, vc) in self.childVCs.enumerated() {
            self.addChild(vc)
            scrollView.addSubview(vc.view)
            vc.view.frame = CGRect(x: CGFloat(index) * scrollW, y: 0, width: scrollW, height: scrollH)
        }
        scrollView.contentSize = CGSize(width: CGFloat(self.childVCs.count) * scrollW, height: 0)
        
        return scrollView
    }()
    
}

extension GKDemoTestViewController: GKPageScrollViewDelegate {
    func headerView(in pageScrollView: GKPageScrollView) -> UIView {
        headerView
    }
    
    func pageView(in pageScrollView: GKPageScrollView) -> UIView {
        pageView
    }
    
    func listView(in pageScrollView: GKPageScrollView) -> [GKPageListViewDelegate] {
        childVCs
    }
}

extension GKDemoTestViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.pageScrollView.horizonScrollViewWillBeginScroll()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.pageScrollView.horizonScrollViewDidEndedScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.pageScrollView.horizonScrollViewDidEndedScroll()
    }
}

extension GKDemoTestViewController: JXSegmentedViewDelegate {
    
}
