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


class ViewController: UIViewController {
    
    var dataArray: [Battery]?
    
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
                    let model = try JSONDecoder().decode(Model.self, from: response.data)
//                    let model = try JSONDecoder().decode(Model.self, from: jsonStr.data(using: .utf8)!)
//                    let model = try JSONDecoder().decode(Model.self, from: response.data)
                    myPrint(model)
                    if let data = model.data.first {
                        self.dataArray = data.batteries
                        self.collectionView.reloadData()
                    }
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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(AnimationPlayCollectionViewCell.self), for: indexPath) as! AnimationPlayCollectionViewCell
        if let model = self.dataArray?[indexPath.item] {
            cell.battery = model
        }
        return cell
    }
    
    
    
    
    
}
