//
//  UIViewController+Extensions.swift
//  DrawingToday
//
//  Created by 이진욱 on 2021/01/11.
//

import UIKit

extension UIViewController {
    /// 네비게이션 바 숨김
    func hideNavigationBar(shouldHide: Bool = true) {
        self.navigationController?.isNavigationBarHidden = shouldHide
    }
    /// 네비게이션 화면 푸쉬
    func push(to viewController: UIViewController, animated: Bool = false) {
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
    /// 네비게이션 화면 팝
    func popNavigation(animated: Bool = true) {
        self.navigationController?.popViewController(animated: animated)
    }
    /// 특정 뷰 컨트롤러로 전환
    func popToViewController(_ viewController: UIViewController, animated: Bool = true) {
        self.navigationController?.popToViewController(viewController, animated: animated)
    }
    /// 네비게이션 최상위 뷰 컨트롤러로 전환
    func popToRoot(animated: Bool = true) {
        self.navigationController?.popToRootViewController(animated: animated)
    }
}
