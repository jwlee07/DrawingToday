//
//  ARCameraViewController.swift
//  DrawingToday
//
//  Created by 이진욱 on 2021/01/11.
//

import UIKit
import ARKit

class ARCameraViewController: BaseViewController {
    // MARK: - Properties
    // AR
    final lazy var sceneView = ARSCNView()
    let configuration = ARWorldTrackingConfiguration()
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        buildView()
        defaultSettingAR()
    }
    private func buildView() {
        createViews()
    }
}
// MARK: - AR
extension ARCameraViewController {
    private func defaultSettingAR() {
        let sceneViewOptions: ARSession.RunOptions = [.resetTracking, .removeExistingAnchors]
        sceneView.session.run(configuration, options: sceneViewOptions)
        sceneView.showsStatistics = true
        sceneView.delegate = self
    }
}
// MARK: - ARSCNViewDelegate
extension ARCameraViewController: ARSCNViewDelegate {
    
}
// MARK: - BaseViewSettingProtocol
extension ARCameraViewController: BaseViewSettingProtocol {
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
