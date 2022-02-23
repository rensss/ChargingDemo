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
        p.isLazyLoadList = true
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
    
    lazy var titleDataSource: JXSegmentedTitleDataSource  = {
        let t = JXSegmentedTitleDataSource()
        t.titleNormalColor = UIColor.gray
        t.titleSelectedColor = UIColor.red
        t.titleNormalFont = UIFont.systemFont(ofSize: 15.0)
        t.titleSelectedFont = UIFont.systemFont(ofSize: 15.0)
        t.reloadData(selectedIndex: 0)
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
        
        segmentedView.contentScrollView = self.pageScrollView.listContainerView.collectionView
        
        let btmLineView = UIView()
        btmLineView.backgroundColor = UIColor.xnRandomColor()
        segmentedView.addSubview(btmLineView)
        btmLineView.snp.makeConstraints({ (make) in
            make.left.right.bottom.equalTo(segmentedView)
            make.height.equalTo(ADAPTATIONRATIO * 2.0)
        })
        
        return segmentedView
    }()
}

extension GKDemoTestViewController: GKPageScrollViewDelegate {
    
    func shouldLazyLoadList(in pageScrollView: GKPageScrollView) -> Bool {
        true
    }
    
    func headerView(in pageScrollView: GKPageScrollView) -> UIView {
        headerView
    }
    
    func segmentedView(in pageScrollView: GKPageScrollView) -> UIView {
        segmentedView
    }
    
    func numberOfLists(in pageScrollView: GKPageScrollView) -> Int {
        self.model?.data.count ?? 1
    }
    
    func pageScrollView(_ pageScrollView: GKPageScrollView, initListAtIndex index: Int) -> GKPageListViewDelegate {
        let child = GKDemoTestChildView()
        if let model = self.model?.data[index] {
            child.model = model
        }
        self.addChild(child)
        return child
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
