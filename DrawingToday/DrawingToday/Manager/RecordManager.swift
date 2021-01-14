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
}
