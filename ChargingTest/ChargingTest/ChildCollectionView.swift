//
//  ChildCollectionView.swift
//  ChargingTest
//
//  Created by Rzk on 2022/2/17.
//

import UIKit

class ChildCollectionView: UICollectionView, UIGestureRecognizerDelegate {
    
    var isCanScroll: Bool? {
        didSet {
            if let isCanScroll = isCanScroll {
                if isCanScroll {
                    self.contentOffset = CGPoint.zero
                }
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}
