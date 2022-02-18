//
//  RootScrollView.swift
//  ChargingTest
//
//  Created by Rzk on 2022/2/17.
//

import UIKit

class RootScrollView: BaseScrollView, UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
