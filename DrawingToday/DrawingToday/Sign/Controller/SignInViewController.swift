//
//  SignInViewController.swift
//  DrawingToday
//
//  Created by 이진욱 on 2021/01/19.
//

import UIKit
import AuthenticationServices

class SignInViewController: BaseViewController {
    // MARK: - Properties
    let appleLoginButton = ASAuthorizationAppleIDButton()
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        buildViews()
        defaultSettingLoginButton()
    }
    override func buildViews() {
        createViews()
    }
}
// MARK: - Apple Helper
extension SignInViewController {
    private func defaultSettingAppleLogin() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let appleRequest = appleIDProvider.createRequest()
        appleRequest.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [appleRequest])
        authorizationController.delegate = self // 로그인 성공/실패 시 처리를 위한 채택
        authorizationController.presentationContextProvider = self // 로그인 요청 창을 띄우기 위한 채택
        authorizationController.performRequests()
    }
}
// MARK: - Apple ASAuthorizationControllerDelegate
extension SignInViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        let userIdentfier = appleIDCredential.user
        SignInManager.shared.appleUserGetInfo(appleIDCredential: appleIDCredential)
        SignInManager.shared.appleUserGetCredentialState(userIdentfier: userIdentfier)
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("didCompleteWithError error : ", error.localizedDescription)
    }
}
// MARK: - Apple ASAuthorizationControllerPresentationContextProviding
extension SignInViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}
// MARK: - Common Helper
extension SignInViewController {
    private func defaultSettingLoginButton() {
        appleLoginButton.addTarget(self, action: #selector(didTapAppleLoginButton(sender:)), for: .touchUpInside)
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
        [appleLoginButton].forEach {
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
        [appleLoginButton].forEach {
            $0.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(padding)
                $0.trailing.equalToSuperview().offset(-padding)
                $0.height.equalTo(buttonHeight)
            }
        }
        appleLoginButton.snp.makeConstraints {
            $0.center.equalTo(view.snp.center)
        }
    }
    func createViews() {
        setAddSubViews()
        setBasics()
        setLayouts()
    }
}
