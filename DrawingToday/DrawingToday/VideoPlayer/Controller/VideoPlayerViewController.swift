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
    let padding: CGFloat = 16
    lazy var videoPlayerView = VideoPlayerView(viewWidth: (deviceWidth * widthRatio) - (padding * 2), viewHeight: (deviceHeight * heightRatio) / 2)
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        buildViews()
        print("deviceHeight : ", deviceHeight)
        print("heightRatio : ", heightRatio)
        print("(deviceHeight * heightRatio) / 2 : ", (deviceHeight * heightRatio) / 2 )
    }
    override func buildViews() {
        createViews()
    }
}
// MARK: - UI
extension VideoPlayerViewController: BaseViewSettingProtocol {
    func setAddSubViews() {
        view.addSubview(videoPlayerView)
    }
    func setBasics() {
        hideNavigationBar()
        videoPlayerView.clipsToBounds = true
        videoPlayerView.layer.cornerRadius = 30
    }
    func setLayouts() {
        videoPlayerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(padding)
            $0.leading.equalToSuperview().offset(padding)
            $0.trailing.equalToSuperview().offset(-padding)
            $0.height.equalTo((deviceWidth * UIScreen.widthRatio) / 2)
        }
    }
    func createViews() {
        setAddSubViews()
        setBasics()
        setLayouts()
    }
}
