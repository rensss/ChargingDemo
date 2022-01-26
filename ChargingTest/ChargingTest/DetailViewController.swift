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
        
        view.addSubview(playerView)
        playerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let b = UIButton()
        b.setImage(UIImage(named: "ic_close"), for: .normal)
        b.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        view.addSubview(b)
        b.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(45)
            make.leading.equalToSuperview().offset(25)
            make.width.height.equalTo(40)
        }
        sessionManager = appDelegate.sessionManager
        
        if let name = try? battery?.video?.url.asURL().lastPathComponent {
            download(sessionManager: appDelegate.sessionManager, url: battery?.video?.url, filename: "or_" + name)
        } else if let name = try? battery?.previewVideo?.url.asURL().lastPathComponent {
            download(sessionManager: appDelegate.sessionManager, url: battery?.previewVideo?.url, filename: "or_" + name)
        }
        
        setupManager()
    }
    
    // MARK:- event
    @objc func btnClick(btn: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK:- func
    func setupManager() {
        // 设置 manager 的回调
        sessionManager?.completion(handler: { [weak self] manager in
            if manager.status == .succeeded {
                // 下载成功
                if let name = try? self?.battery?.video?.url.asURL().lastPathComponent {
                    let pathStr = manager.cache.downloadFilePath + "/" + "or_" + name
//                    myPrint(pathStr)
                    self?.path = pathStr
                    self?.playVideo()
                } else if let name = try? self?.battery?.previewVideo?.url.asURL().lastPathComponent {
                    let pathStr = manager.cache.downloadFilePath + "/" + "or_" + name
//                    myPrint(pathStr)
                    self?.path = pathStr
                    self?.playVideo()
                }
            } else {
                // 其他状态
            }
        })
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
        player.playerLayer.videoGravity = .resizeAspect
        return player
    }()
}
