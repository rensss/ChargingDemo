//
//  SectionHeaderCollectionReusableView.swift
//  ChargingTest
//
//  Created by Rzk on 2022/2/16.
//

import UIKit

class SectionHeaderCollectionReusableView: UICollectionReusableView {
    var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(randomWithAlpha: 1)
        
        self.createView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createView() {
        
        self.titleLabel = UILabel()
        self.addSubview(self.titleLabel)
        
        self.titleLabel.snp.makeConstraints { (make) in
            make.width.greaterThanOrEqualTo(0)
            make.height.equalTo(30)
            make.center.equalToSuperview()
        }
    }
}
