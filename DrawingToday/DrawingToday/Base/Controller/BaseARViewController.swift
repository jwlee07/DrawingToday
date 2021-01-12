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
    var stickerColorStatus: ColorState = .blue
    var drawingColorStatus: ColorState = .blue
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
}
// MARK: - AR
extension BaseARViewController {
    /// AR Default Setting
    private func defaultSettingAR() {
        let sceneViewOptions: ARSession.RunOptions = [.resetTracking, .removeExistingAnchors]
        sceneView.session.run(configuration, options: sceneViewOptions)
        sceneView.showsStatistics = true
        sceneView.automaticallyUpdatesLighting = true
        sceneView.delegate = self
    }
    /// 스티커 Geometry, Color, Position 설정 후 추가
    private func addStickerNode(sticker: StickerGeometryState, color: ColorState, position: SCNVector3) {
        let stickerNode = SCNNode()
        // Size
        let stickerSize: CGFloat = 0.2
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
        stickerNode.geometry?.firstMaterial?.diffuse.contents = colorReturn(color: color)
        stickerNode.position = position
        sceneView.scene.rootNode.addChildNode(stickerNode)
    }
    /// DrawingNode 생성 후 Color, Position 설정 후 추가
    private func addDrawingNode(color: ColorState, position: SCNVector3) {
        let drawingSize: CGFloat = 0.03
        let drawingNode = SCNNode()
        drawingNode.geometry = SCNSphere(radius: drawingSize)
        drawingNode.geometry?.firstMaterial?.diffuse.contents = colorReturn(color: color)
        drawingNode.position = position
        sceneView.scene.rootNode.addChildNode(drawingNode)
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
// MARK: - ARSCNViewDelegate
extension BaseARViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        guard shouldDrawing && !shouldSticker else { return }
        addDrawingNode(color: drawingColorStatus, position: currentPosition())
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
    private func colorReturn(color: ColorState) -> UIColor {
        switch color {
        case .red:
            return UIColor.systemRed
        case .blue:
            return UIColor.systemBlue
        }
    }
}
// MARK: - Selector
extension BaseARViewController {
    @objc
    private func didTapGesture(_ sender: UITapGestureRecognizer) {
        switch sender {
        case stickerTapGesture:
            guard shouldSticker && !shouldDrawing else { return }
            addStickerNode(sticker: stickerGeometryStatus, color: stickerColorStatus, position: currentPosition())
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
