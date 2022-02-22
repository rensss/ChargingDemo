//
//  GKDemoTestChildView.swift
//  ChargingTest
//
//  Created by Rzk on 2022/2/22.
//

import UIKit

class GKDemoTestChildView: UIViewController {
    
    let itemSpacing = 13.0
    let padding = 16.0
    let itemWidth = 165.0
    let itemHeight = 287.0
    
    var scrollCallBack: ((UIScrollView) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//
//        var frame = self.view.frame
//        frame.size = (self.view.superview?.bounds.size)!
//        self.view.frame = frame
//    }
    
    // MARK: - func
    func setupUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - setter
    var model: Datum? {
        didSet {
            if let _ = model {
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - lazy
    lazy var collectionView: ChildCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let width = (screenWidth - itemSpacing - padding * 2)/2.0
        let height = width * itemHeight / itemWidth
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumLineSpacing = itemSpacing
        layout.minimumInteritemSpacing = itemSpacing
        
        let c = ChildCollectionView(frame: .zero, collectionViewLayout: layout)
        
        c.delegate = self
        c.dataSource = self
        c.backgroundColor = .clear
        c.contentInset = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
        
        c.register(AnimationPlayCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(AnimationPlayCollectionViewCell.self))
        
        return c
    }()
}

extension GKDemoTestChildView {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let callBack = scrollCallBack {
            callBack(scrollView)
        }
    }
}

extension GKDemoTestChildView: GKPageListViewDelegate {
    
    func listScrollView() -> UIScrollView {
        return self.collectionView
    }
    
    func listViewDidScroll(callBack: @escaping (UIScrollView) -> ()) {
        scrollCallBack = callBack
    }
}

extension GKDemoTestChildView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.model?.batteries.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(AnimationPlayCollectionViewCell.self), for: indexPath) as! AnimationPlayCollectionViewCell
        if let model = self.model?.batteries[indexPath.item] {
            cell.battery = model
        }
        return cell
    }
}
