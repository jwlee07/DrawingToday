//
//  SignInManager.swift
//  DrawingToday
//
//  Created by 이진욱 on 2021/01/19.
//

import Foundation
import AuthenticationServices
import Firebase
import FirebaseAuth
import CryptoKit

class SignInManager {
    // MARK: - Properties
    static let shared = SignInManager()
    // MARK: - Init
    private init() {}
}
// MARK: - Apple
extension SignInManager {
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
// MARK: - Helper
extension SignInManager {
    /// 암호로 보호된 nonce 생성
    func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: Array<Character> = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length
      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
          }
          return random
        }
        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }
          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }
      return result
    }
    /// sha256 전환
    func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
      }.joined()

      return hashString
    }
}
