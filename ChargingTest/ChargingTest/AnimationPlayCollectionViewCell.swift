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
    
    // The AVPlayer
    var videoPlayer: AVPlayer? = nil
    var task: Tiercel.DownloadTask?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        self.backgroundColor = UIColor.withRandom()
        
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
        
        contentView.addSubview(playerView)
        playerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    // MARK:-- play
    func playVideo() {
        // path of the video in the bundle
        guard let string = try? self.battery?.previewVideo?.url.asURL().lastPathComponent else {
            myPrint("lastPathComponent not exist")
            return
        }
        
        self.playerView.isHidden = false
        
        let pathStr = appDelegate.sessionManager.cache.downloadFilePath + "/" + string
        myPrint(pathStr)
        
        // set the video player with the path
        videoPlayer = AVPlayer(url: URL(fileURLWithPath: pathStr))
        // play the video now!
        videoPlayer?.playImmediately(atRate: 1)
        // setup the AVPlayer as the player
        playerView.player = videoPlayer
        
//        coverImage.image = nil
    }
    
    func stopVideo() {
        playerView.player?.pause()
    }
    
    // The PlayerView
    var playerView: PlayerView = {
        var player = PlayerView()
        player.backgroundColor = .clear
        player.playerLayer.videoGravity = .resizeAspectFill
        return player
    }()
    
    // MARK:- setter
    var battery: Battery? {
        didSet {
            guard let name = try? battery?.previewVideo?.url.asURL().lastPathComponent else { return }
            
            task = download(sessionManager: appDelegate.sessionManager, url: battery?.previewVideo?.url, filename: name)
            
            if let url = battery?.previewImage?.url {
                coverImage.contentMode = .scaleAspectFit
                coverImage.kf.setImage(with: URL(string: url), placeholder: UIImage(named: "placeholder")) { result in
                    switch result {
                    case .success(let res):
                        self.coverImage.contentMode = .scaleAspectFill
//                        myPrint("---- \(String(describing: res.source.url?.absoluteString))")
                        self.playerView.isHidden = true
                    case .failure(let error):
                        myPrint(error)
                    }
                }
            }
        }
    }
    
    // MARK:- lazy
    lazy var coverImage: UIImageView = {
        let c = UIImageView()
        c.contentMode = .scaleAspectFill
        c.clipsToBounds = true
        return c
    }()
    
}
