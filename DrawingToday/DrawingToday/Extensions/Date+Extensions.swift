//
//  Date+Extensions.swift
//  DrawingToday
//
//  Created by 이진욱 on 2021/01/13.
//

import Foundation

extension Date {
    /// 금일 날짜 Date -> String 변환
    func getToday() {
        let fomatter = DateFormatter()
        fomatter.dateFormat = "yyyy-MM-dd"
        let today = fomatter.string(from: Date())
        print("today : ", today)
    }
}
