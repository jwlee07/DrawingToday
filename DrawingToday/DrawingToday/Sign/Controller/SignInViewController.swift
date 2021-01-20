//
//  SignInViewController.swift
//  DrawingToday
//
//  Created by 이진욱 on 2021/01/19.
//

import UIKit
import AuthenticationServices
import Firebase
import GoogleSignIn

class SignInViewController: BaseViewController {
    // MARK: - Properties
    private let appleLoginButton = ASAuthorizationAppleIDButton()
    private let googleLoginButton = GIDSignInButton()
    private var loginHandel: AuthStateDidChangeListenerHandle?
    fileprivate var currentNonce: String?
    private var userInfo = UserInfo(userName: "", userEmail: "")
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        buildViews()
        defaultSettingLoginButton()
        defaultSettingGoogleLogin()
        getUserInfo()
    }
    override func buildViews() {
        createViews()
    }
}
// MARK: - Auth
extension SignInViewController {
    /// 사용자 이름, Email 가져오기
    private func getUserInfo() {
        loginHandel = Auth.auth().addStateDidChangeListener({ (_, user) in
            guard let user = user else { return print("user Error") }
            guard let userName = user.displayName else { return }
            guard let userEmail = user.email else { return }
            print("userName : ", userName)
            print("userEmail : ", userEmail)
            self.userInfo.userName = userName
            self.userInfo.userEmail = userEmail
            print("userInfo.userName : ", self.userInfo.userName)
            print("userInfo.userEmail : ", self.userInfo.userEmail)

        })
    }
}
// MARK: - Helper
extension SignInViewController {
    /// Apple Login Default Setting
    private func defaultSettingAppleLogin() {
        let nonce = SignInManager.shared.randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = SignInManager.shared.sha256(nonce)
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    /// Google Login Default Setting
    private func defaultSettingGoogleLogin() {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    private func defaultSettingLoginButton() {
        appleLoginButton.addTarget(self, action: #selector(didTapAppleLoginButton(sender:)), for: .touchUpInside)
    }
}
// MARK: - Apple ASAuthorizationControllerDelegate
extension SignInViewController: ASAuthorizationControllerDelegate {
    // Apple FireBase Auth
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        let userIdentifier = appleIDCredential.user
        guard let nonce = currentNonce else { fatalError() }
        guard let appleIDToken = appleIDCredential.identityToken else { return }
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else { return }
        let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                  idToken: idTokenString,
                                                  rawNonce: nonce)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            guard error != nil else { return }
            print("authResult) : ", authResult!)
        }
        SignInManager.shared.appleUserGetCredentialState(userIdentfier: userIdentifier)
        // Login Error 발생 시
        func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
            print("apple Login Error : ", error)
        }
    }
}

// MARK: - Apple ASAuthorizationControllerPresentationContextProviding
extension SignInViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}
// MARK: - Selector
extension SignInViewController {
    @objc
    private func didTapAppleLoginButton(sender: ASAuthorizationAppleIDButton) {
        defaultSettingAppleLogin()
    }
}

// MARK: - UI
extension SignInViewController: BaseViewSettingProtocol {
    func setAddSubViews() {
        [appleLoginButton,
         googleLoginButton].forEach {
            view.addSubview($0)
         }
    }
    func setBasics() {
        hideNavigationBar()
    }
    func setLayouts() {
        // 레이아웃 수치
        let buttonHeight: CGFloat = 48
        let padding: CGFloat = 32
        // 레이아웃 설정
        [appleLoginButton,
         googleLoginButton].forEach {
            $0.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(padding)
                $0.trailing.equalToSuperview().offset(-padding)
                $0.height.equalTo(buttonHeight)
            }
         }
        appleLoginButton.snp.makeConstraints {
            $0.top.equalTo(view.snp.centerY)
        }
        googleLoginButton.snp.makeConstraints {
            $0.top.equalTo(appleLoginButton.snp.bottom).offset(padding)
        }
    }
    func createViews() {
        setAddSubViews()
        setBasics()
        setLayouts()
    }
}
