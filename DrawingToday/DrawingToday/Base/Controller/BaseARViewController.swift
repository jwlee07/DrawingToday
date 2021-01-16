//
//  BaseARViewController.swift
//  DrawingToday
//
//  Created by 이진욱 on 2021/01/11.
//

import UIKit
import ARKit
import ARVideoKit
import Photos

class BaseARViewController: BaseViewController {
    // MARK: - Properties
    // AR
    final lazy var sceneView = ARSCNView()
    let configuration = ARWorldTrackingConfiguration()
    var stickerGeometryStatus: StickerGeometryState = .box
    var stickerColorStatus: ColorState = .blue
    var drawingColorStatus: ColorState = .blue
    var shouldDetectFace = false
    // ARVideo
    var recorder: RecordAR?
    let recordingQueue = DispatchQueue(label: "recordingThread", attributes: .concurrent)
    // Bool
    var shouldSticker = true
    var shouldDrawing = false
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        buildView()
        defaultSettingAR()
        defaultSettingRecord()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recorder?.rest()
    }
    private func buildView() {
        createViews()
    }
}
// MARK: - AR
extension BaseARViewController {
    /// AR Default Setting
    private func defaultSettingAR() {
        let sceneViewOptions: ARSession.RunOptions = [.resetTracking, .removeExistingAnchors]
        sceneView.session.run(configuration, options: sceneViewOptions)
        sceneView.automaticallyUpdatesLighting = true
        sceneView.delegate = self
    }
}
// MARK: - RecordAR
extension BaseARViewController {
    /// Record Default Setting
    private func defaultSettingRecord() {
        recorder = RecordAR(ARSceneKit: sceneView)
        recorder?.prepare(configuration)
        recorder?.onlyRenderWhileRecording = false // AR Rendering 비활성화
        recorder?.enableAdjustEnvironmentLighting = true // 비디오, 사진 조명 렌더링
        recorder?.inputViewOrientations = [.landscapeLeft, .landscapeRight, .portrait] // VC 방향설정
        recorder?.deleteCacheWhenExported = false // Cache Data 지우기
    }
}
// MARK: - ARSCNViewDelegate
extension BaseARViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        DispatchQueue.main.async {
            guard self.shouldDrawing && !self.shouldSticker else { return }
            ARManager.shared.addDrawingNode(sceneView: self.sceneView,
                                            color: self.drawingColorStatus,
                                            position: ARManager.shared.currentPosition(sceneView: self.sceneView))
        }
    }
}
// MARK: - BaseViewSettingProtocol
extension BaseARViewController: BaseViewSettingProtocol {
    func setAddSubViews() {
        view.addSubview(sceneView)
    }
    func setBasics() {
        sceneView.automaticallyUpdatesLighting = true
        hideNavigationBar()
    }
    func setLayouts() {
        sceneView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    func createViews() {
        setAddSubViews()
        setBasics()
        setLayouts()
    }
}
