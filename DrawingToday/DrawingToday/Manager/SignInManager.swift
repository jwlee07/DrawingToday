//
//  SignInManager.swift
//  DrawingToday
//
//  Created by 이진욱 on 2021/01/19.
//

import Foundation
import AuthenticationServices

class SignInManager {
    // MARK: - Properties
    static let shared = SignInManager()
    // MARK: - Init
    private init() {}
}
// MARK: - Apple
extension SignInManager {
    /// Apple User 이름, Email 정보 가져오기
    func appleUserGetInfo(appleIDCredential: ASAuthorizationAppleIDCredential) {
        let userFirstName = appleIDCredential.fullName?.givenName
        let userLastName = appleIDCredential.fullName?.familyName
        let userEmail = appleIDCredential.email
        guard let firstName = userFirstName,
              let lastName = userLastName,
              let email = userEmail else { return }
        print("firstName : ", firstName)
        print("email : ", email)
        AppleUserInfo.init(firstName: firstName, lastName: lastName, email: email)
    }
    /// Apple ID 자격증명 상태에 따라 처리
    func appleUserGetCredentialState(userIdentfier: String) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: userIdentfier) { (credentialState, error) in
            guard error == nil else { return }
            switch credentialState {
            case .authorized: // Apple ID 자격증명 유효
                break
            case .revoked: // Apple ID 자격증명 취소
                break
            case .notFound: // Apple ID 자격증명 없음
                break
            default:
                break
            }
        }
    }
}
