//
//  VideoPlayerView.swift
//  DrawingToday
//
//  Created by 이진욱 on 2021/01/18.
//

import UIKit
import AVKit
import AVFoundation

class VideoPlayerView: UIView {
    // MARK: - Properties
    let videoPlayer = AVPlayer()
    lazy var videoPlayerLayer = AVPlayerLayer(player: videoPlayer)
    var videoFileName: String = "test"
    var videoType: String = "mp4"
    // MARK: - Init
    init(viewWidth: CGFloat, viewHeight: CGFloat) {
        super.init(frame: .zero)
        buildViews()
        videoPlayerLayer.frame = CGRect(x: 0,
                                        y: 0,
                                        width: viewWidth,
                                        height: viewHeight)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func buildViews() {
        createViews()
        PlayerManager.shared.playVideoWithFileName(player: videoPlayer, filName: videoFileName, fileType: videoType)
    }
}
// MARK: - UI
extension VideoPlayerView: BaseViewSettingProtocol {
    func setAddSubViews() {
        self.layer.addSublayer(videoPlayerLayer)
    }
    func setBasics() {
        videoPlayerLayer.videoGravity = .resizeAspectFill
    }
    func setLayouts() {
    }
    func createViews() {
        setAddSubViews()
        setBasics()
        setLayouts()
    }
}
