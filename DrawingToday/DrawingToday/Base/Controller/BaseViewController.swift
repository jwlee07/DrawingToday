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
    // Device 가로, 세로 길이
    let deviceWidth = UIScreen.screenWidth
    let deviceHeight = UIScreen.screenHeight
    // Device 가로, 세로 비율
    let widthRatio = UIScreen.widthRatio
    let heightRatio = UIScreen.heightRatio
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
