//
//  DetailViewController.swift
//  ChargingTest
//
//  Created by Rzk on 2022/1/24.
//

import UIKit
import Tiercel
import AVFoundation
import AVKit
import R_category

class DetailViewController: UIViewController {
    
    var sessionManager: SessionManager?
    var battery: Battery?
    var path: String?
    var videoPlayer: AVPlayer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        sessionManager = appDelegate.sessionManager
        
        setupManager()
        
        download(sessionManager: sessionManager, url: battery?.previewVideo?.url)
        
        view.addSubview(playerView)
        playerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK:- func
    func setupManager() {
        // 设置 manager 的回调
        sessionManager?.progress { [weak self] (manager) in
//            self?.updateUI()
        }.completion { [weak self] manager in
//            self?.updateUI()
            if manager.status == .succeeded {
                // 下载成功
                if let string = try? self?.battery?.previewVideo?.url.asURL().lastPathComponent {
                    let pathStr = manager.cache.downloadFilePath + "/" + string
                    myPrint(pathStr)
                    self?.path = pathStr
                    self?.playVideo()
                }
            } else {
                // 其他状态
            }
        }
    }
    
    func playVideo() {
        // path of the video in the bundle
        guard let pathStr = self.path else { return }
//        myPrint(pathStr)
        
        // set the video player with the path
        videoPlayer = AVPlayer(url: URL(fileURLWithPath: pathStr))
        // play the video now!
        videoPlayer?.playImmediately(atRate: 1)
        // setup the AVPlayer as the player
        playerView.player = videoPlayer
    }
    
    func stopVideo() {
        playerView.player?.pause()
    }
    
    // MARK:- lazy
    lazy var playerView: PlayerView = {
        var player = PlayerView()
        player.backgroundColor = .clear
        return player
    }()
}
