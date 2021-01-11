//
//  SceneDelegate.swift
//  DrawingToday
//
//  Created by 이진욱 on 2021/01/10.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        initiateWindow(scene: windowScene)
    }
    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}
fileprivate extension SceneDelegate {
    final private func initiateWindow(scene: UIWindowScene, backgroundColor: UIColor = .systemBackground) {
        let windowCopy = UIWindow(windowScene: scene)
        windowCopy.backgroundColor = backgroundColor
        windowCopy.rootViewController = applicationRootViewController()
        windowCopy.makeKeyAndVisible()
        window = windowCopy
    }
    final private func applicationRootViewController() -> UIViewController {
        #if DEBUG
        #endif
        return UINavigationController(rootViewController: ARCameraViewController())
    }
}
