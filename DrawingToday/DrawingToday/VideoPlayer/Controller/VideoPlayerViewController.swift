//
//  VideoPlayerViewController.swift
//  DrawingToday
//
//  Created by 이진욱 on 2021/01/16.
//

import UIKit
import AVKit
import AVFoundation

class VideoPlayerViewController: BaseViewController {
    // MARK: - Properties
    let videoPlayer = AVPlayer()
    lazy var videoPlayerLayer = AVPlayerLayer(player: videoPlayer)
    var videoFileName: String = "test"
    var videoType: String = "mp4"
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar()
        buildViews()
        PlayerManager.shared.playVideoWithFileName(player: videoPlayer, filName: videoFileName, fileType: videoType)
    }
    override func buildViews() {
        createViews()
    }
}
// MARK: - UI
extension VideoPlayerViewController: BaseViewSettingProtocol {
    func setAddSubViews() {
        view.layer.addSublayer(videoPlayerLayer)
    }
    func setBasics() {
        videoPlayerLayer.videoGravity = .resizeAspectFill
    }
    func setLayouts() {
        let padding: CGFloat = 32
        videoPlayerLayer.frame = CGRect(x: 0,
                                        y: 0,
                                        width: deviceWidth - padding,
                                        height: deviceHeight - padding)
    }
    func createViews() {
        setAddSubViews()
        setBasics()
        setLayouts()
    }
}
