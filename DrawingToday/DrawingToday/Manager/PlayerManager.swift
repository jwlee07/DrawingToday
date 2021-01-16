//
//  PlayerManager.swift
//  DrawingToday
//
//  Created by 이진욱 on 2021/01/17.
//

import AVKit
import AVFoundation

class PlayerManager {
    // MARK: - Properties
    static let shared = PlayerManager()
    // MARK: - Init
    private init() {}
    // MARK: - Func
    /// 비디오 파일 경로를 입력받아 재생
    func playVideoWithFileName(player: AVPlayer, filName: String, fileType: String) {
        guard let filePath = Bundle.main.path(forResource: filName, ofType: fileType) else { return }
        let videoURL = URL(fileURLWithPath: filePath)
        let playItem = AVPlayerItem(url: videoURL)
        player.replaceCurrentItem(with: playItem)
        player.play()
    }
}
