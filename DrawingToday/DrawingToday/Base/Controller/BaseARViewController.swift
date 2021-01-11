//
//  BaseARViewController.swift
//  DrawingToday
//
//  Created by 이진욱 on 2021/01/11.
//

import UIKit
import ARKit

class BaseARViewController: UIViewController {
    // MARK: - Properties
    // AR
    final lazy var sceneView = ARSCNView()
    let configuration = ARWorldTrackingConfiguration()
    let positionZero = SCNVector3(0, 0, 0)
    var stickerGeometryStatus: StickerGeometryState = .box
    var stickerColorStatus: StickerColorState = .blue
    // Tap
    var stickerTapGesture = UITapGestureRecognizer()
    // Bool
    var shouldSticker = true
    var shouldDrawing = false
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        buildView()
        defaultSettingAR()
        defaultSettingTapGesutre()
    }
    private func buildView() {
        createViews()
    }
}
// MARK: - Tap
extension BaseARViewController {
    /// Tap 생성 후 AddTarget
    private func defaultSettingTapGesutre() {
        // Tap Set
        stickerTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapGesture(_:)))
        // AddGestureRecognizer
        [stickerTapGesture].forEach {
            sceneView.addGestureRecognizer($0)
        }
    }
    /// StickerMode 시 Tap 실행
    private func didTapTouchStickerMode(sender: UITapGestureRecognizer) {
        guard let sceneViewTapOn = sender.view as? SCNView else { return }
        let touchCooridinatos = sender.location(in: sceneViewTapOn)
        let hitTest = sceneViewTapOn.hitTest(touchCooridinatos)
        let stickerPoint = hitTest.first
        addStickerNode(sticker: stickerGeometryStatus, color: stickerColorStatus, position: currentPosition())
    }
}
// MARK: - AR
extension BaseARViewController {
    /// AR Default Setting
    private func defaultSettingAR() {
        let sceneViewOptions: ARSession.RunOptions = [.resetTracking, .removeExistingAnchors]
        sceneView.session.run(configuration, options: sceneViewOptions)
        sceneView.showsStatistics = true
        sceneView.delegate = self
    }
    /// 스티커 Geometry, Color, Position 설정
    private func addStickerNode(sticker: StickerGeometryState, color: StickerColorState, position: SCNVector3) {
        let stickerNode = SCNNode()
        // Size
        let stickerSize: CGFloat = 0.3
        let stickerRadius: CGFloat = 0.1
        let zero: CGFloat = 0
        switch sticker {
        case .box:
            stickerNode.geometry = SCNBox(width: stickerSize,
                                          height: stickerSize,
                                          length: stickerSize,
                                          chamferRadius: stickerSize * 0.1)
        case .cone:
            stickerNode.geometry = SCNCone(topRadius: zero,
                                           bottomRadius: stickerSize,
                                           height: stickerSize)
        case .pyramid:
            stickerNode.geometry = SCNPyramid(width: stickerSize,
                                              height: stickerSize,
                                              length: stickerSize)
        case .sphere:
            stickerNode.geometry = SCNSphere(radius: stickerSize)
        case .torus:
            stickerNode.geometry = SCNTorus(ringRadius: stickerSize,
                                            pipeRadius: stickerSize - stickerRadius)
        }
        stickerNode.geometry?.firstMaterial?.diffuse.contents = stickerColorReturn(stickerColor: color)
        stickerNode.position = position
        sceneView.scene.rootNode.addChildNode(stickerNode)
    }
    /// 현재 위치에서 방향값 쿼터니연 더하기 연산
    private func currentPosition() -> SCNVector3 {
        guard let pointOfView = sceneView.pointOfView else { return positionZero}
        let transform = pointOfView.transform
        let orientation = SCNVector3(-transform.m31,
                                     -transform.m32,
                                     -transform.m33)
        let location = SCNVector3(transform.m41,
                                  transform.m42,
                                  transform.m43)
        return quaternionAdd(orientation: orientation, locationt: location)
    }
}
// MARK: - Helper
extension BaseARViewController {
    /// 쿼터니온 더하기 연산
    private func quaternionAdd(orientation: SCNVector3, locationt: SCNVector3) -> SCNVector3 {
        return SCNVector3Make(orientation.x + locationt.x,
                              orientation.y + locationt.y,
                              orientation.z + locationt.z)
    }
    /// 스티커 Color 반환
    private func stickerColorReturn(stickerColor: StickerColorState) -> UIColor {
        switch stickerColor {
        case .red:
            return UIColor.systemRed
        case .blue:
            return UIColor.systemBlue
        }
    }
}
// MARK: - ARSCNViewDelegate
extension BaseARViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        if !(shouldSticker) && shouldDrawing {
            addStickerNode(sticker: stickerGeometryStatus, color: stickerColorStatus, position: currentPosition())
        }
    }
}
// MARK: - Selector
extension BaseARViewController {
    @objc
    private func didTapGesture(_ sender: UITapGestureRecognizer) {
        switch sender {
        case stickerTapGesture:
            guard shouldSticker else { return }
            didTapTouchStickerMode(sender: sender)
        default:
            break
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
