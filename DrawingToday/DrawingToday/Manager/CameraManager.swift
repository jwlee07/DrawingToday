//
//  CameraManager.swift
//  DrawingToday
//
//  Created by 이진욱 on 2021/01/13.
//

import ARKit

class CameraManager {
    // MARK: - Properties
    static let shared = CameraManager()
    // MARK: - Init
    private init() {}
    // MARK: - Func
    /// 카메라 포지션 변경 시 ARConfiguration 변경
    func changeARCameraPosition(detectFace: Bool, sceneView: ARSCNView) {
        switch detectFace {
        case true:
            let configuration = ARFaceTrackingConfiguration()
            ARManager.shared.cameraPositionChangeARSetting(sceneView: sceneView, configuration: configuration)
        case false:
            let configuration = ARWorldTrackingConfiguration()
            ARManager.shared.cameraPositionChangeARSetting(sceneView: sceneView, configuration: configuration)
        }
    }
}
