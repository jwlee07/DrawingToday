//
//  SignInUserInfo.swift
//  DrawingToday
//
//  Created by 이진욱 on 2021/01/19.
//

import Foundation

struct UserInfo {
    // MARK: - Properties
    let userName: String
    let userEmail: String
    // MARK: - Init
    init(userName: String, userEmail: String) {
        self.userName = userName
        self.userEmail = userEmail
    }
}
