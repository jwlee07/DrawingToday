//
//  BaseARViewController.swift
//  DrawingToday
//
//  Created by 이진욱 on 2021/01/11.
//

import UIKit
import ARKit

class BaseARViewController: BaseViewController {
    // MARK: - Properties
    // AR
    final lazy var sceneView = ARSCNView()
    let configuration = ARWorldTrackingConfiguration()
    var stickerGeometryStatus: StickerGeometryState = .box
    var stickerColorStatus: ColorState = .blue
    var drawingColorStatus: ColorState = .blue
    // Tap
    var stickerTapGesture = UITapGestureRecognizer()
    // Bool
    var shouldSticker = true
    var shouldDrawing = false
    #if DEBUG
    // TEST
    let createNodeTestButton = UIButton()
    let changeNodeTestButton = UIButton()
    let resetNodeTestButton = UIButton()
    #endif
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        buildView()
        defaultSettingAR()
        #if DEBUG
        setTestButton()
        #endif
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
// MARK: - ARSCNViewDelegate
extension BaseARViewController: ARSCNViewDelegate {
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
#if DEBUG
// MARK: - TEST
extension BaseARViewController {
    private func setTestButton() {
        let buttonWidth: CGFloat = 100
        let buttonHeight: CGFloat = 50
        let padding: CGFloat = 16
        createNodeTestButton.setTitle("생성", for: .normal)
        createNodeTestButton.backgroundColor = .systemRed
        changeNodeTestButton.setTitle("전환", for: .normal)
        changeNodeTestButton.backgroundColor = .systemBlue
        resetNodeTestButton.setTitle("초기화", for: .normal)
        resetNodeTestButton.backgroundColor = .systemGreen
        [createNodeTestButton,
         changeNodeTestButton,
         resetNodeTestButton].forEach {
            $0.clipsToBounds = false
            $0.layer.cornerRadius = buttonWidth * 0.1
            $0.addTarget(self, action: #selector(didTapTestButton(_:)), for: .touchUpInside)
            sceneView.addSubview($0)
            $0.snp.makeConstraints {
                $0.width.equalTo(buttonWidth)
                $0.height.equalTo(buttonHeight)
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-padding)
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
            sceneView.session.pause()
            sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
                node.removeFromParentNode()
            }
            sceneView.session.run(configuration)
        default:
            break
        }
    }
}
#endif
