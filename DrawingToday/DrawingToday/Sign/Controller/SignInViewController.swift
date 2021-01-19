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
    let appleLoginButton = ASAuthorizationAppleIDButton()
    let googleLoginButton = GIDSignInButton()
    fileprivate var currentNonce: String?
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        buildViews()
        defaultSettingLoginButton()
        defaultSettingGoogleLogin()
    }
    override func buildViews() {
        createViews()
    }
}
// MARK: - Helper
extension SignInViewController {
    /// Apple Login Default Setting
    @available(iOS 13, *)
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
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
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
        let padding: CGFloat = 16
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
            $0.center.equalTo(view.snp.center)
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
