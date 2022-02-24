//
//  ViewController.swift
//  ChargingTest
//
//  Created by Rzk on 2022/1/18.
//

import UIKit
import SnapKit
import Moya
import SwiftyJSON
import SwiftUI
import Kingfisher
import Tiercel

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height
let statusBarHeight = UIWindow.xnKeyWindow()?.windowScene?.statusBarManager?.statusBarFrame.height

public func myPrint(_ items: Any..., filename: String = #file, function: String = #function, line: Int = #line) {
    #if DEBUG
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.sss"
    print("\(dateFormatter.string(from: Date()))【\((filename as NSString).lastPathComponent) \(line) \(function)】", items)
    #endif
}

let cellReuseridentifier = "cellReuseridentifier"

public func download(sessionManager: SessionManager?, url: String?, filename: String?) -> Tiercel.DownloadTask? {
    if let url = url, let filename = filename {
//        myPrint("---- download url: " + url)
        return sessionManager?.download(url, fileName: filename)
        
//        guard let downloadURLStrings = sessionManager?.tasks.map( { $0.url.absoluteString } ) else { return }
//
//        if downloadURLStrings.contains(where: { $0 == url}) { return }
        
//        sessionManager?.download(url, fileName: filename, handler: { task in
//            myPrint(task.status)
//        })
    } else {
        return nil
    }
}

class ViewController: UIViewController {
    
    var dataArray: [Battery]?
    var model: Model?
    
    let headerViewHeight: CGFloat = 300.0
    let categroyHeight: CGFloat = 45.0
    
    var isCanMianScrollView: Bool = true
    var currentChildScrollView: ChildCollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        KingfisherManager.shared.downloader.downloadTimeout = 600
//        KingfisherManager.shared.downloader.trustedHosts = ["appicon.cocomobi.com"]
//        KingfisherManager.shared.cache.diskStorage.config.expiration = .days(7)
        
//        let a: String = "abc"
//        let array = a.map { String($0) }
//        myPrint(array)
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        requestList()
        
        let button = UIButton()
        button.setTitle("Local", for: .normal)
        button.backgroundColor = UIColor.withRandom()
        button.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-80)
        }
    }
    
    // MARK: - event
    @objc func btnClick() {
//        let vc = LocalAnimationViewController()
//        let nav = UINavigationController(rootViewController: vc)
////        nav.modalPresentationStyle = .fullScreen
//        self.present(nav, animated: true, completion: nil)
        
//        let newHome = NewHomeViewController()
//        newHome.model = self.model
//        newHome.modalPresentationStyle = .fullScreen
//        self.present(newHome, animated: true, completion: nil)
        
//        let newCollectionVC = CollectionViewViewController()
////        newCollectionVC.model = model
//        let nav = UINavigationController(rootViewController: newCollectionVC)
//        nav.modalPresentationStyle = .fullScreen
//        self.present(nav, animated: true, completion: nil)
        
        let gkVC = GKDemoTestViewController()
        gkVC.model = model
        gkVC.modalPresentationStyle = .fullScreen
        self.present(gkVC, animated: true, completion: nil)
    }
    
    // MARK: - func
    func requestList() {
        NetworkAPIRequest.request(.tags("zh", "1.24", false)) { result in
            switch result {
            case .success(let response):
//                let str = String(data: response.data, encoding: .utf8)
//                let jsonObject = try? JSONSerialization.jsonObject(with: response.data, options: [])
//                myPrint(jsonObject ?? "")
                do {
                    self.model = try JSONDecoder().decode(Model.self, from: response.data)
                    self.pageCollectionView.reloadData()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                        self.visibilityCell()
                    }
                } catch {
                    myPrint("---- \(error)")
                }
            case .failure(let error):
                myPrint("---- \(error)")
            }
        }
    }
    
    // MARK: - lazy
    lazy var headerView: UIView = {
        let h = UIView()
        h.backgroundColor = .purple
        return h
    }()
    
    lazy var scrollView: RootScrollView = {
        let s = RootScrollView()
        s.delegate = self
        s.showsVerticalScrollIndicator = false
        
        s.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(headerViewHeight)
        }
        
        s.addSubview(pageCollectionView)
        
        s.contentSize = CGSize(width: screenWidth, height: (headerViewHeight + screenHeight) - categroyHeight - statusBarHeight)
        
        return s
    }()
    
    lazy var pageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: screenWidth, height: screenHeight - categroyHeight - statusBarHeight)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let c = UICollectionView(frame: CGRect(x: 0, y: headerViewHeight, width: screenWidth, height: screenHeight - categroyHeight - statusBarHeight), collectionViewLayout: layout)
        c.delegate = self
        c.dataSource = self
        c.isPagingEnabled = true
        c.backgroundColor = .white
//        c.alwaysBounceHorizontal = true
        c.showsHorizontalScrollIndicator = false
        
        c.register(PageCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(PageCollectionViewCell.self))
        return c
    }()
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource , UIScrollViewDelegate {
    
    // MARK: - UIScrollDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let bottomOffset = headerViewHeight - categroyHeight - statusBarHeight
        
        if scrollView == self.pageCollectionView {
//            if let cell = self.pageCollectionView.visibleCells.first as? PageCollectionViewCell {
//                let isScrollEnabled = self.currentChildScrollView?.isScrollEnabled ?? false
//                self.currentChildScrollView = cell.collectionView
//
//                self.currentChildScrollView?.isScrollEnabled = isScrollEnabled
//                self.scrollView.isScrollEnabled = !isScrollEnabled
//            }
        } else {
            myPrint("---- \(bottomOffset) \(type(of: scrollView)):\(scrollView.contentOffset.y)")
        }
        
        if scrollView is RootScrollView {
            self.currentChildScrollView?.isScrollEnabled = false
            if scrollView.contentOffset.y >= bottomOffset {
                scrollView.contentOffset = CGPoint(x: 0, y: bottomOffset)
                self.scrollView.isScrollEnabled = false
                self.currentChildScrollView?.isScrollEnabled = true
            } else {
                self.scrollView.isScrollEnabled = true
            }
        }
        
        if scrollView is ChildCollectionView && !self.scrollView.isScrollEnabled {
            self.currentChildScrollView?.isScrollEnabled = true
            if scrollView.contentOffset.y < 0 {
                self.scrollView.isScrollEnabled = true
                self.currentChildScrollView?.isScrollEnabled = false
            } else {
                
            }
        }
    }
    
    // 滑动结束的判断
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollViewDidEndScroll(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let stop = !scrollView.isTracking && !scrollView.isDragging && !scrollView.isDecelerating
        if stop {
            scrollViewDidEndScroll(scrollView)
        }
    }
    
    //isPagingEnabled 为 true 时不需要此方法配合
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let stop = scrollView.isTracking && !scrollView.isDragging && !scrollView.isDecelerating
        if stop {
//            scrollViewDidEndScroll(scrollView)
        }
    }
    
    func scrollViewDidEndScroll(_ scrollView: UIScrollView) {
        if scrollView == self.pageCollectionView {
            if let cell = self.pageCollectionView.visibleCells.first as? PageCollectionViewCell {
                let isScrollEnabled = self.currentChildScrollView?.isScrollEnabled ?? false
                myPrint("---- isScrollEnabled: \(isScrollEnabled)")
                self.currentChildScrollView = cell.collectionView
                
                self.currentChildScrollView?.isScrollEnabled = isScrollEnabled
                self.scrollView.isScrollEnabled = !isScrollEnabled
            }
        }
    }
    
    // MARK: - collectionView delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.model?.data.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(PageCollectionViewCell.self), for: indexPath) as! PageCollectionViewCell
        
        cell.model = self.model?.data[indexPath.item]
//        cell.collectionView.delegate = self
        
        if self.currentChildScrollView == nil {
            self.currentChildScrollView = cell.collectionView
            cell.collectionView.isScrollEnabled = false
            self.scrollView.isScrollEnabled = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let vc = DetailViewController()
//        vc.modalPresentationStyle = .fullScreen
//        if let model = self.model?.batteries[indexPath.item] {
//            vc.battery = model
//        }
//        self.present(vc, animated: true, completion: nil)
    }
    
    
    
    // MARK: - video 播放
    func visibilityCell() {
//        let visibleCells = self.collectionView.indexPathsForVisibleItems
//            .sorted { top, bottom -> Bool in
//                return top.section < bottom.section || top.row < bottom.row
//            }.compactMap { indexPath -> UICollectionViewCell? in
//                return self.collectionView.cellForItem(at: indexPath)
//            }
////        let cellCount = visibleCells.count
//        for item in visibleCells {
//            if let cell = item as? AnimationPlayCollectionViewCell {
//                cell.playVideo()
//            }
//        }
////        let indexPaths = self.collectionView.indexPathsForVisibleItems.sorted()
////        for (index, item) in indexPaths.enumerated() {
////            guard let firstCell = visibleCells[index] as? AnimationPlayCollectionViewCell else {return}
//////            checkVisibilityOfCell(cell: firstCell, indexPath: item)
////            firstCell.playVideo()
////        }
//
////        guard let firstCell = visibleCells.first as? AnimationPlayCollectionViewCell, let firstIndex = indexPaths.first else {return}
////        checkVisibilityOfCell(cell: firstCell, indexPath: firstIndex)
////        if cellCount == 1 {return}
////        guard let lastCell = visibleCells.last as? AnimationPlayCollectionViewCell, let lastIndex = indexPaths.last else {return}
////        checkVisibilityOfCell(cell: lastCell, indexPath: lastIndex)
    }
    
//    func checkVisibilityOfCell(cell: AnimationPlayCollectionViewCell, indexPath: IndexPath) {
//        if let cellRect = (collectionView.layoutAttributesForItem(at: indexPath)?.frame) {
//            let completelyVisible = collectionView.bounds.contains(cellRect)
//            if completelyVisible {
//                cell.playVideo()
//            } else {
//                cell.stopVideo()
//            }
//        }
//    }
}
