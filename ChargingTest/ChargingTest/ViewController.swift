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

public func myPrint(_ items: Any..., filename: String = #file, function: String = #function, line: Int = #line) {
    #if DEBUG
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.sss"
    print("\(dateFormatter.string(from: Date()))【\((filename as NSString).lastPathComponent) \(line) \(function)】", items)
    #endif
}

let cellReuseridentifier = "cellReuseridentifier"

public func download(sessionManager: SessionManager?, url: String?, filename: String?) {
    if let url = url, let filename = filename {
        myPrint("---- download url: " + url)
        
//        guard let downloadURLStrings = sessionManager?.tasks.map( { $0.url.absoluteString } ) else { return }
//
//        if downloadURLStrings.contains(where: { $0 == url}) { return }
        
        sessionManager?.multiDownload([url], fileNames: [filename])
        
//        sessionManager?.download(url, fileName: filename, handler: { task in
//            myPrint(task.status)
//        })
    }
}

class ViewController: UIViewController {
    
    var dataArray: [Battery]?
    var model: Model?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        KingfisherManager.shared.downloader.downloadTimeout = 600
//        KingfisherManager.shared.downloader.trustedHosts = ["appicon.cocomobi.com"]
//        KingfisherManager.shared.cache.diskStorage.config.expiration = .days(7)
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.size.equalToSuperview()
            make.edges.equalToSuperview()
        }
        
        requestList()
    }
    
    // MARK:- func
    func requestList() {
        NetworkAPIRequest.request(.tags("zh", "1.24", false)) { result in
            switch result {
            case .success(let response):
//                let str = String(data: response.data, encoding: .utf8)
//                let jsonObject = try? JSONSerialization.jsonObject(with: response.data, options: [])
//                myPrint(jsonObject ?? "")
                do {
                    self.model = try JSONDecoder().decode(Model.self, from: response.data)
//                    let model = try JSONDecoder().decode(Model.self, from: jsonStr.data(using: .utf8)!)
//                    let model = try JSONDecoder().decode(Model.self, from: response.data)
//                    myPrint(model)
//                    if let data = model.data.first {
//                        self.dataArray = data.batteries
                        self.collectionView.reloadData()
//                    }
                } catch {
                    myPrint("---- \(error)")
                }
            case .failure(let error):
                myPrint("---- \(error)")
            }
        }
    }
    
    
    // MARK:- lazy
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (screenWidth - 30)/2.0, height: 400)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        
        let c = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        c.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        c.backgroundColor = .white
        c.delegate = self
        c.dataSource = self
        c.alwaysBounceVertical = true
        c.register(AnimationPlayCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(AnimationPlayCollectionViewCell.self))
        return c
    }()
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.model?.data.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.model?.data[section].batteries.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(AnimationPlayCollectionViewCell.self), for: indexPath) as! AnimationPlayCollectionViewCell
        if let model = self.model?.data[indexPath.section].batteries[indexPath.item] {
            cell.battery = model
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.modalPresentationStyle = .fullScreen
        if let model = self.model?.data[indexPath.section].batteries[indexPath.item] {
            vc.battery = model
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        myPrint("---- UIScrollView停止滚动了")
        
        visibilityCell()
    }
    
    //isPagingEnabled 为 true 时不需要此方法配合
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //停止拖拉，即手离开屏幕，但手抬起后，UIScrollView也停止滑动了。
        if decelerate == false {
            scrollViewDidEndDecelerating(scrollView)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        myPrint("---- scrollViewDidScroll")
    }
    
    func visibilityCell() {
        let visibleCells = self.collectionView.indexPathsForVisibleItems
            .sorted { top, bottom -> Bool in
                return top.section < bottom.section || top.row < bottom.row
            }.compactMap { indexPath -> UICollectionViewCell? in
                return self.collectionView.cellForItem(at: indexPath)
            }
//        let cellCount = visibleCells.count
        for item in visibleCells {
            if let cell = item as? AnimationPlayCollectionViewCell {
                cell.playVideo()
            }
        }
//        let indexPaths = self.collectionView.indexPathsForVisibleItems.sorted()
//        for (index, item) in indexPaths.enumerated() {
//            guard let firstCell = visibleCells[index] as? AnimationPlayCollectionViewCell else {return}
////            checkVisibilityOfCell(cell: firstCell, indexPath: item)
//            firstCell.playVideo()
//        }
        
//        guard let firstCell = visibleCells.first as? AnimationPlayCollectionViewCell, let firstIndex = indexPaths.first else {return}
//        checkVisibilityOfCell(cell: firstCell, indexPath: firstIndex)
//        if cellCount == 1 {return}
//        guard let lastCell = visibleCells.last as? AnimationPlayCollectionViewCell, let lastIndex = indexPaths.last else {return}
//        checkVisibilityOfCell(cell: lastCell, indexPath: lastIndex)
    }
    
    func checkVisibilityOfCell(cell: AnimationPlayCollectionViewCell, indexPath: IndexPath) {
        if let cellRect = (collectionView.layoutAttributesForItem(at: indexPath)?.frame) {
            let completelyVisible = collectionView.bounds.contains(cellRect)
            if completelyVisible {cell.playVideo()} else {cell.stopVideo()}
        }
    }
    
}
