//
//  MapButton.swift
//  DrawingToday
//
//  Created by 이진욱 on 2021/01/10.
//

import UIKit

class MapButton: UIButton {
    // MARK: - Properties
    let buttonImageView = UIImageView()
    init(imageName: String) {
        super.init(frame: .zero)
        setButton()
        setImageView()
        buttonImageView.image = UIImage(systemName: imageName)?.withTintColor(.systemBackground,
                                                                              renderingMode: .alwaysOriginal)
        buttonImageView.image!.withTintColor(.systemBackground, renderingMode: .alwaysOriginal)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - UI
extension MapButton {
    func setButton() {
        self.clipsToBounds = false
    }
    func setImageView() {
        buttonImageView.contentMode = .scaleAspectFit
        buttonImageView.isUserInteractionEnabled = false
        self.addSubview(buttonImageView)
        buttonImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
