//
//  LocalAnimationViewController.swift
//  ChargingTest
//
//  Created by Rzk on 2022/2/9.
//

import UIKit

let w = 323.0
let h = 699.0

class LocalAnimationViewController: UIViewController {
    
    let width = ((screenWidth - 10.0 * 3) / 2.0)
    let height = ((screenWidth - 10.0 * 3) / 2.0) * h / w
    let padding = 10.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "local"
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.size.equalToSuperview()
            make.edges.equalToSuperview()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.visibilityCell()
        }
    }
    
    // MARK: - lazy
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = padding
        
        let c = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        c.contentInset = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
        c.backgroundColor = .white
        c.delegate = self
        c.dataSource = self
        c.alwaysBounceVertical = true
        c.register(AnimationPlayCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(AnimationPlayCollectionViewCell.self))
        return c
    }()
    
    lazy var dataArray: [String] = {
        let a = [
            "charging_animation_1",
            "charging_animation_2",
            "charging_animation_3",
            "charging_animation_4",
            "charging_animation_5",
            "charging_animation_6",
            "charging_animation_7",
            "charging_animation_8",
            "charging_animation_9",
            "charging_animation_10",
        ]
        return a
    }()
    
    
}

extension LocalAnimationViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(AnimationPlayCollectionViewCell.self), for: indexPath) as! AnimationPlayCollectionViewCell
        
        cell.backgroundColor = UIColor.withRandom()
        cell.localPath = self.dataArray[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.localPath = self.dataArray[indexPath.item]
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
