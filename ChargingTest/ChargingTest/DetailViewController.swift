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
import MBProgressHUD

class DetailViewController: UIViewController {
    
    var sessionManager: SessionManager?
    var battery: Battery?
    var path: String?
    var videoPlayer: AVPlayer? = nil
    var videoTask: Tiercel.DownloadTask?
    var localPath: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(coverImage)
        coverImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
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
        
        if let localPath = localPath {
            self.path = Bundle.main.path(forResource: localPath, ofType: "mp4")
            self.playVideo()
            return
        }
        
        sessionManager = appDelegate.sessionManager
        
        setupManager()
        
        MBProgressHUD.xnShowIndicatorWithHideAfterYOffset("loading...", showView: self.view)
        
        if let name = try? battery?.video?.url.asURL().lastPathComponent {
            self.videoTask = download(sessionManager: appDelegate.sessionManager, url: battery?.video?.url, filename: "or_" + name)
        } else if let name = try? battery?.previewVideo?.url.asURL().lastPathComponent {
            self.videoTask = download(sessionManager: appDelegate.sessionManager, url: battery?.previewVideo?.url, filename: "or_" + name)
        }
    }
    
    deinit {
        myPrint("---- \(self) 销毁了！")
    }
    
    // MARK:- notification
    @objc func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            if playerItem == self.playerView.player?.currentItem {
                playerItem.seek(to: CMTime.zero, completionHandler: nil)
            }
        }
    }
    
    // MARK: - event
    @objc func btnClick(btn: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - func
    func setupManager() {
        // 设置 manager 的回调
        sessionManager?.completion(handler: { [weak self] manager in
            
            if self?.videoTask?.status == .succeeded {
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
                myPrint("---- \(String(describing: self?.videoTask?.status))")
            }
        })
    }
    
    func playVideo() {
        MBProgressHUD.xnHideHUD(self.view)
        
        // path of the video in the bundle
        guard let pathStr = self.path else {
            myPrint("path wrong!")
            return
        }
//        myPrint(pathStr)
        
        // set the video player with the path
        videoPlayer = AVPlayer(url: URL(fileURLWithPath: pathStr))
        // play the video now!
        videoPlayer?.playImmediately(atRate: 1)
        // setup the AVPlayer as the player
        playerView.player = videoPlayer
        
        videoPlayer?.actionAtItemEnd = .none
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd(notification:)), name: .AVPlayerItemDidPlayToEndTime, object: videoPlayer?.currentItem)
    }
    
    func stopVideo() {
        playerView.player?.pause()
    }
    
    // MARK: - lazy
    lazy var playerView: PlayerView = {
        var player = PlayerView()
        player.backgroundColor = .clear
        player.playerLayer.videoGravity = .resizeAspect
        return player
    }()
    
    lazy var coverImage: UIImageView = {
        let c = UIImageView()
        c.contentMode = .scaleAspectFill
        c.clipsToBounds = true
        
        if let url = battery?.previewImage?.url {
            c.contentMode = .scaleAspectFit
            c.kf.setImage(with: URL(string: url), placeholder: UIImage(named: "placeholder")) { result in
                switch result {
                case .success(let res):
                    c.contentMode = .scaleAspectFill
                case .failure(let error):
                    myPrint(error)
                }
            }
        }
        
        return c
    }()
}
