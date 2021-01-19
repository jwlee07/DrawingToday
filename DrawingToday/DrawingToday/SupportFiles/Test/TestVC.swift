//
//  TestVC.swift
//  DrawingToday
//
//  Created by 이진욱 on 2021/01/15.
//

import UIKit
import ARKit
import ARVideoKit
import Photos

class TestVC: BaseViewController {
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
    #if DEBUG
    // TEST
    let createNodeTestButton = UIButton()
    let changeNodeTestButton = UIButton()
    let resetNodeTestButton = UIButton()
    let changeCameraPositionButton = UIButton()
    let recordTestButton = UIButton()
    let pauseBTestButton = UIButton()
    #endif
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        buildView()
        defaultSettingAR()
        defaultSettingRecord()
        #if DEBUG
        setTestButton()
        #endif
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
extension TestVC {
    /// AR Default Setting
    private func defaultSettingAR() {
        let sceneViewOptions: ARSession.RunOptions = [.resetTracking, .removeExistingAnchors]
        sceneView.session.run(configuration, options: sceneViewOptions)
        sceneView.automaticallyUpdatesLighting = true
        sceneView.delegate = self
    }
}
// MARK: - RecordAR
extension TestVC {
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
extension TestVC: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        DispatchQueue.main.async {
            guard self.shouldDrawing && !self.shouldSticker else { return }
            guard self.createNodeTestButton.isHighlighted else { return }
            ARManager.shared.addDrawingNode(sceneView: self.sceneView,
                                            color: self.drawingColorStatus,
                                            position: ARManager.shared.currentPosition(sceneView: self.sceneView))
        }
    }
}
// MARK: - BaseViewSettingProtocol
extension TestVC: BaseViewSettingProtocol {
    func setAddSubViews() {
        view.addSubview(sceneView)
    }
    func setBasics() {
        sceneView.automaticallyUpdatesLighting = true
        hideNavigationBar(shouldHide: true)
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
#if DEBUG
// MARK: - TEST
extension TestVC {
    private func setTestButton() {
        let buttonWidth: CGFloat = 100
        let buttonHeight: CGFloat = 50
        let padding: CGFloat = 16
        createNodeTestButton.setTitle("생성", for: .normal)
        createNodeTestButton.backgroundColor = .systemRed
        changeNodeTestButton.setTitle("노드전환", for: .normal)
        changeNodeTestButton.backgroundColor = .systemBlue
        resetNodeTestButton.setTitle("초기화", for: .normal)
        resetNodeTestButton.backgroundColor = .systemTeal
        changeCameraPositionButton.setTitle("카메라", for: .normal)
        changeCameraPositionButton.backgroundColor = .systemIndigo
        recordTestButton.setTitle("영상녹화시작", for: .normal)
        recordTestButton.backgroundColor = .systemGreen
        pauseBTestButton.setTitle("영상화면보기", for: .normal)
        pauseBTestButton.backgroundColor = .systemPink
        [createNodeTestButton,
         changeNodeTestButton,
         resetNodeTestButton,
         changeCameraPositionButton,
         recordTestButton,
         pauseBTestButton].forEach {
            $0.clipsToBounds = false
            $0.layer.cornerRadius = buttonWidth * 0.1
            $0.addTarget(self, action: #selector(didTapTestButton(_:)), for: .touchUpInside)
            sceneView.addSubview($0)
            $0.snp.makeConstraints {
                $0.width.equalTo(buttonWidth)
                $0.height.equalTo(buttonHeight)
            }
         }
        [createNodeTestButton,
         changeNodeTestButton,
         resetNodeTestButton].forEach {
            $0.snp.makeConstraints {
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-padding)
            }
         }
        [changeCameraPositionButton,
         recordTestButton,
         pauseBTestButton].forEach {
            $0.snp.makeConstraints {
                $0.bottom.equalTo(createNodeTestButton.snp.top).offset(-padding)
            }
         }
        createNodeTestButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-padding)
        }
        changeNodeTestButton.snp.makeConstraints {
            $0.trailing.equalTo(createNodeTestButton.snp.leading).offset(-padding)
        }
        resetNodeTestButton.snp.makeConstraints {
            $0.trailing.equalTo(changeNodeTestButton.snp.leading).offset(-padding)
        }
        changeCameraPositionButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-padding)
        }
        recordTestButton.snp.makeConstraints {
            $0.trailing.equalTo(changeCameraPositionButton.snp.leading).offset(-padding)
        }
        pauseBTestButton.snp.makeConstraints {
            $0.trailing.equalTo(recordTestButton.snp.leading).offset(-padding)
        }
    }
    @objc
    func didTapTestButton(_ sender: UIButton) {
        switch sender {
        case createNodeTestButton:
            guard shouldSticker && !shouldDrawing else { return }
            ARManager.shared.addStickerNode(sceneView: sceneView,
                                            sticker: stickerGeometryStatus,
                                            color: stickerColorStatus,
                                            position: ARManager.shared.currentPosition(sceneView: sceneView))
        case changeNodeTestButton:
            shouldSticker = !shouldSticker
            shouldDrawing = !shouldDrawing
        case resetNodeTestButton:
            RecordManager.shared.changeARCameraPosition(detectFace: shouldDetectFace, recorder: recorder, sceneView: sceneView)
        case changeCameraPositionButton:
            shouldDetectFace = !shouldDetectFace
            RecordManager.shared.changeARCameraPosition(detectFace: shouldDetectFace, recorder: recorder, sceneView: sceneView)
        case recordTestButton:
            RecordManager.shared.videoRecordering(sender: recordTestButton, recorder: recorder)
        case pauseBTestButton:
            let videoVC = VideoPlayerViewController()
            videoVC.view.backgroundColor = .systemBackground
            push(to: videoVC, animated: true)
        default:
            break
        }
    }
}
#endif
