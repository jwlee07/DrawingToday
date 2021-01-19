//
//  SignInUserInfo.swift
//  DrawingToday
//
//  Created by 이진욱 on 2021/01/19.
//

import Foundation

struct AppleUserInfo {
    // MARK: - Properties
    let firstName: String // User First Name
    let lastName: String // User First Name
    let email: String // User Email
    // MARK: - Init
    init(firstName: String, lastName: String, email: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
}
