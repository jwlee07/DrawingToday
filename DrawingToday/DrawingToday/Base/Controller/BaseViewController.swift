//
//  BaseViewController.swift
//  DrawingToday
//
//  Created by 이진욱 on 2021/01/10.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
// MARK: - BaseViewSettingProtocol
protocol BaseViewSettingProtocol {
    func setAddSubViews()
    func setBasics()
    func setLayouts()
    func createViews()
}
