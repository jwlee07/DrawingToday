//
//  UIScreen+Extensions.swift
//  DrawingToday
//
//  Created by 이진욱 on 2021/01/18.
//

import UIKit

extension UIScreen {
    static let screenWidth = UIScreen.main.bounds.width // Device의 가로 길이
    static let screenHeight = UIScreen.main.bounds.height // Device의 세로 길이
    static let widthRatio = UIScreen.screenWidth / 375 // Device의 표준 가로길이 기준으로 비율 생성
    static let heightRatio = UIScreen.screenHeight / 812 // Device의 표준 가로길이 기준으로 비율 생성
    static let shouldResize: Bool = UIScreen.screenHeight < 812 ? true : false // Device 세로길이 기준으로 reSize 여부 확인
}
