//
//  ColorManager.swift
//  DrawingToday
//
//  Created by 이진욱 on 2021/01/12.
//

import UIKit

enum ColorState {
    case red
    case blue
}

class ColorManager {
    // MARK: - Properties
    static let shared = ColorManager()
    // MARK: - Init
    private init() {}
    // MARK: - Func
    /// Color 반환
    func colorReturn(color: ColorState) -> UIColor {
        switch color {
        case .red:
            return UIColor.systemRed
        case .blue:
            return UIColor.systemBlue
        }
    }

}
