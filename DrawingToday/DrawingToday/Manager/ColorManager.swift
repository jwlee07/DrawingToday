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
    static let shared = ColorManager()
    private init() {}
    
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
