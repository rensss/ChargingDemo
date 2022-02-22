//
//  ContentViewController.swift
//  ChargingTest
//
//  Created by Rzk on 2022/2/17.
//

import UIKit
import SegementSlide

class ContentViewController: UIViewController, SegementSlideContentScrollViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - func
    func setupUI() {
//        view.addSubview(collectionView)
//        collectionView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - SegementSlideContentScrollViewDelegate
    @objc var scrollView: UIScrollView {
        return self.tableView
    }
    
    // MARK: - setter
    var model: Datum? {
        didSet {
            if let _ = model {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - lazy
    lazy var tableView: UITableView = {
        let t = UITableView()
        t.rowHeight = screenHeight - statusBarHeight - 44.0 - safeAreaInsets.bottom
        t.delegate = self
        t.dataSource = self
        t.separatorStyle = .none
        t.tableFooterView = UIView()
        t.showsVerticalScrollIndicator = false
        t.register(ContentTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(ContentTableViewCell.self))
        return t
    }()
    
}

extension ContentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(ContentTableViewCell.self), for: indexPath) as! ContentTableViewCell
        
        cell.model = self.model
        
        return cell
    }
}


