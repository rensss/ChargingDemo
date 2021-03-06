//
//  ContentTableViewCell.swift
//  ChargingTest
//
//  Created by Rzk on 2022/2/21.
//

import UIKit

class ContentTableViewCell: UITableViewCell {
    
    let itemSpacing = 13.0
    let padding = 16.0
    let itemWidth = 165.0
    let itemHeight = 287.0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
//        layout.headerReferenceSize = CGSize(width: screenWidth, height: 50)
//        layout.sectionHeadersPinToVisibleBounds = true
        
        let c = ChildCollectionView(frame: self.bounds, collectionViewLayout: layout)
        
        c.delegate = self
        c.dataSource = self
        c.backgroundColor = .clear
        c.contentInset = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
//        c.alwaysBounceVertical = true
//        c.isScrollEnabled = false
        
        c.register(AnimationPlayCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(AnimationPlayCollectionViewCell.self))
        c.register(SectionHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NSStringFromClass(SectionHeaderCollectionReusableView.self))
        return c
    }()
    
}

extension ContentTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        return CGSize(width: screenWidth, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var header: SectionHeaderCollectionReusableView! = SectionHeaderCollectionReusableView()
        if kind == UICollectionView.elementKindSectionHeader {
            
            header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: NSStringFromClass(SectionHeaderCollectionReusableView.self), for: indexPath) as? SectionHeaderCollectionReusableView
            
            header.titleLabel.text = self.model?.name
        }
        
        return header
    }
    
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
