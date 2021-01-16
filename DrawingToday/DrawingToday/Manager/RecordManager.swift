//
//  RecordManager.swift
//  DrawingToday
//
//  Created by 이진욱 on 2021/01/15.
//

import ARKit
import ARVideoKit
import Photos

class RecordManager {
    // MARK: - Properties
    static let shared = RecordManager()
    let recordingQueue = DispatchQueue(label: "recordingThread", attributes: .concurrent)
    // MARK: - Init
    private init() {}
    // MARK: - Func
    /// 카메라 포지션 변경 시  Recoder ARConfiguration 변경  
    func changeARCameraPosition(detectFace: Bool, recorder: RecordAR?, sceneView: ARSCNView) {
        switch detectFace {
        case true:
            let configuration = ARFaceTrackingConfiguration()
            ARManager.shared.cameraPositionChangeARSetting(sceneView: sceneView, configuration: configuration)
            recorder?.prepare(configuration)
        case false:
            let configuration = ARWorldTrackingConfiguration()
            ARManager.shared.cameraPositionChangeARSetting(sceneView: sceneView, configuration: configuration)
            recorder?.prepare(configuration)
        }
    }
    /// 미디어 파일 처리에 대한 알림 메세지 Present
    func exportMessage(success: Bool, status: PHAuthorizationStatus) {
        guard !success else { return print("성공")}
        switch status {
        case .denied, .restricted, .notDetermined:
            print("사진 라이브러리에 대한 액세스 허용이 되어 있지 않습니다.")
            // 사진 라이브러리 설정 변경을 하기 위한 설정 진입
            guard let settingUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            guard UIApplication.shared.canOpenURL(settingUrl) else { return }
            UIApplication.shared.open(settingUrl) { success in
                print("success : ", success)
            }
        case .authorized, .limited:
            print("미디어 파일 Export 시 오류 발생")
        @unknown default:
            print("미디어 파일 확인되지 않은 오류 발생")
        }
    }
    /// 비디오 레코딩 시작, 종료 기능 With Duration
    func videoRecordering(sender: UIButton, recorder: RecordAR?) {
        switch recorder?.status {
        case .readyToRecord:
            sender.setTitle("영상녹화종료", for: .normal)
            recordingQueue.async {
                recorder?.record(forDuration: 15, { path in
                    recorder?.export(video: path) { saved, status in
                        print("readyToRecord saved : ", saved)
                        DispatchQueue.main.sync {
                            sender.setTitle("영상녹화시작", for: .normal)
                            self.exportMessage(success: saved, status: status)
                        }
                    }
                })
            }
        case .recording:
            sender.setTitle("영상녹화시작", for: .normal)
            recorder?.stop({ path in
                print("recording path : ", path)
                recorder?.export(video: path) { saved, status in
                    DispatchQueue.main.sync {
                        self.exportMessage(success: saved, status: status)
                    }
                }
            })
        default:
            break
        }
    }
}
