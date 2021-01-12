//
//  ARManager.swift
//  DrawingToday
//
//  Created by 이진욱 on 2021/01/12.
//

import ARKit

class ARManager {
    // MARK: - Properties
    static let shared = ARManager()
    let positionZero = SCNVector3(0, 0, 0)
    // MARK: - Init
    private init() {}
    // MARK: - Func
    /// 스티커 Geometry, Color, Position 설정 후 추가
    func addStickerNode(sceneView: ARSCNView, sticker: StickerGeometryState, color: ColorState, position: SCNVector3) {
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
        stickerNode.geometry?.firstMaterial?.diffuse.contents = ColorManager.shared.colorReturn(color: color)
        stickerNode.position = position
        sceneView.scene.rootNode.addChildNode(stickerNode)
    }
    /// DrawingNode 생성 후 Color, Position 설정 후 추가
    func addDrawingNode(sceneView: ARSCNView, color: ColorState, position: SCNVector3) {
        let drawingSize: CGFloat = 0.03
        let drawingNode = SCNNode()
        drawingNode.geometry = SCNSphere(radius: drawingSize)
        drawingNode.geometry?.firstMaterial?.diffuse.contents = ColorManager.shared.colorReturn(color: color)
        drawingNode.position = position
        sceneView.scene.rootNode.addChildNode(drawingNode)
    }
    /// 현재 위치에서 방향값 쿼터니연 더하기 연산
    func currentPosition(sceneView: ARSCNView) -> SCNVector3 {
        guard let pointOfView = sceneView.pointOfView else { return positionZero }
        let transform = pointOfView.transform
        let orientation = SCNVector3(-transform.m31,
                                     -transform.m32,
                                     -transform.m33)
        let location = SCNVector3(transform.m41,
                                  transform.m42,
                                  transform.m43)
        return quaternionAdd(orientation: orientation, locationt: location)
    }
    /// 쿼터니온 더하기 연산
    private func quaternionAdd(orientation: SCNVector3, locationt: SCNVector3) -> SCNVector3 {
        return SCNVector3Make(orientation.x + locationt.x,
                              orientation.y + locationt.y,
                              orientation.z + locationt.z)
    }
}