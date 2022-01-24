//
//  AnimationPlayCollectionViewCell.swift
//  ChargingTest
//
//  Created by Rzk on 2022/1/19.
//

import UIKit
import AVFoundation
import AVKit
import Kingfisher
import R_category
import Result
import Tiercel

class AnimationPlayCollectionViewCell: UICollectionViewCell {
    
    var playerController : AVPlayerViewController? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.withRandom()
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- func
    func setupUI() {
        contentView.addSubview(coverImage)
        coverImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
        
    }
    
    // MARK:- setter
    var path: String? {
        didSet {
            player?.play()
        }
    }
    
    var battery: Battery? {
        didSet {
            if let url = battery?.previewImage?.url {
                coverImage.kf.setImage(with: URL(string: url))
            }
            
            if let url = battery?.previewVideo?.url {
                myPrint(url)
//                let task = sessionManager.download(url)
            }
            
        }
    }
    
    // MARK:- lazy
    lazy var player: AVPlayer? = {
        guard let path = Bundle.main.path(forResource: path, ofType: nil) else { return nil }
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        playerController = AVPlayerViewController()
        if let p = playerController {
            p.player = player
            p.view.frame = CGRect(x: 0, y: 0, width: self.width, height: self.height)
            self.viewController().addChild(p)
            self.viewController().view.addSubview(p.view)
        }
        if let path = self.path {
            let p = AVPlayer(url: URL(fileURLWithPath: path))
            return p
        }
        return nil
    }()
    
    lazy var coverImage: UIImageView = {
        let c = UIImageView()
        c.contentMode = .scaleAspectFill
        c.clipsToBounds = true
        return c
    }()
    
}
