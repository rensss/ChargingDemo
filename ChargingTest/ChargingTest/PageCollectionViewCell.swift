//
//  PageCollectionViewCell.swift
//  ChargingTest
//
//  Created by Rzk on 2022/2/16.
//

import UIKit

class PageCollectionViewCell: UICollectionViewCell {
    
    let itemSpacing = 13.0
    let padding = 16.0
    let itemWidth = 165.0
    let itemHeight = 287.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    func setupUI() {
        contentView.addSubview(collectionView)
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
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        layout.headerReferenceSize = CGSize(width: screenWidth, height: 50)
        layout.sectionHeadersPinToVisibleBounds = true
        
        let c = ChildCollectionView(frame: self.bounds, collectionViewLayout: layout)
        
        c.delegate = self
        c.dataSource = self
        c.backgroundColor = .clear
        c.contentInset = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
        c.alwaysBounceVertical = false
        
        c.register(AnimationPlayCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(AnimationPlayCollectionViewCell.self))
        c.register(SectionHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NSStringFromClass(SectionHeaderCollectionReusableView.self))
        return c
    }()
    
}

extension PageCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.modalPresentationStyle = .fullScreen
        if let model = self.model?.batteries[indexPath.item] {
            vc.battery = model
        }
        self.viewController().present(vc, animated: true, completion: nil)
    }
    
    // 滑动结束的判断
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        r_ScrollViewDidEndScroll(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let stop = !scrollView.isTracking && !scrollView.isDragging && !scrollView.isDecelerating
        if stop {
            r_ScrollViewDidEndScroll(scrollView)
        }
    }
    
    //isPagingEnabled 为 true 时不需要此方法配合
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let stop = scrollView.isTracking && !scrollView.isDragging && !scrollView.isDecelerating
        if stop {
            r_ScrollViewDidEndScroll(scrollView)
        }
    }
    
    func r_ScrollViewDidEndScroll(_ scrollView: UIScrollView) {
        if scrollView == self.collectionView {
            visibilityCell()
        }
    }
    
    // MARK: - video 播放
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
            if completelyVisible {
                cell.playVideo()
            } else {
                cell.stopVideo()
            }
        }
    }
    
}
