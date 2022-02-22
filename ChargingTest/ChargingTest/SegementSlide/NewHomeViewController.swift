//
//  NewHomeViewController.swift
//  ChargingTest
//
//  Created by Rzk on 2022/2/17.
//

import UIKit
import SegementSlide

class NewHomeViewController: SegementSlideDefaultViewController {

    var names: [String]!
    var model: Model? {
        didSet {
            if let model = model {
                names = model.data.map( { $0.name } )
            }
        }
    }
    
    override func segementSlideHeaderView() -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(randomWithAlpha: 1)
        headerView.snp.makeConstraints { make in
            make.height.equalTo(300)
        }
        
        let b = UIButton()
        headerView.addSubview(b)
        b.setImage(UIImage(named: "ic_close"), for: .normal)
        b.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        b.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(45)
            make.leading.equalToSuperview().offset(25)
            make.width.height.equalTo(40)
        }
        
        return headerView
    }
    
    override var titlesInSwitcher: [String] {
        return names
    }
    
    // MARK: - event
    @objc func btnClick(btn: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func segementSlideContentViewController(at index: Int) -> SegementSlideContentScrollViewDelegate? {
        let c = ContentViewController()
        if let model = model {
            c.model = model.data[index]
        }
        return c
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultSelectedIndex = 0
        reloadData()
    }

}
