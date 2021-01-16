//
//  BaseViewController.swift
//  DrawingToday
//
//  Created by 이진욱 on 2021/01/10.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {
    // MARK: - Properties
    let deviceWidth = UIScreen.main.bounds.width
    let deviceHeight = UIScreen.main.bounds.height
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func buildViews() {
    }
}
// MARK: - BaseViewSettingProtocol
protocol BaseViewSettingProtocol {
    func setAddSubViews()
    func setBasics()
    func setLayouts()
    func createViews()
}
