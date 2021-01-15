//
//  MapViewController.swift
//  DrawingToday
//
//  Created by 이진욱 on 2021/01/10.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: BaseViewController {
    // MARK: - Properties
    // Map
    private let mainMap = MKMapView()
    private var userLocationManager = CLLocationManager()
    private var userCurrentLocation: CLLocation!
    // Day
    var dateFomatter = DateFormatter()
    var today: String = ""
    // Button
    private let cameraButton = MapButton(imageName: "camera")
    // Bool
    private var shouldGetUserLocation: Bool = false
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        buildView()
        defaultSettingCoreLocation()
        defaultSettingButton()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        MapManager.shared.locationErrorCheck(locationManager: userLocationManager)
        userLocationManager.delegate = self
    }
    deinit {
        shouldGetUserLocation = false
    }
    private func buildView() {
        createViews()
    }
}
// MARK: - Button
extension MapViewController {
    private func defaultSettingButton() {
        cameraButton.addTarget(self, action: #selector(didTapButton(sender:)), for: .touchUpInside)
    }
}
// MARK: - Selector
extension MapViewController {
    @objc private func didTapButton(sender: UIButton) {
        switch sender {
        case cameraButton:
            shouldGetUserLocation = true
            userLocationManager.startUpdatingLocation()
            Date().getToday()
            push(to: TestVC(), animated: true)
        default:
            break
        }
    }
}
// MARK: - Location
extension MapViewController {
    private func defaultSettingCoreLocation() {
        // mainMap
        mainMap.mapType = MKMapType.standard
        mainMap.showsUserLocation = true
        mainMap.setUserTrackingMode(.follow, animated: true)
        // userLocationManager
        userLocationManager.requestWhenInUseAuthorization() // 앱을 사용할 시 위치 정보에 대한 인증
        userLocationManager.requestAlwaysAuthorization() // 항상 위치 정보에 대한 인증
        userLocationManager.delegate = self
        userLocationManager.desiredAccuracy = kCLLocationAccuracyBest // 위치 정확도
        userLocationManager.startUpdatingLocation() // 사용자 현재 위치 업데이트
        userLocationManager.startMonitoringSignificantLocationChanges()
    }
}
// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        MapManager.shared.locationAllowSet(locationManager: manager,
                                           status: status)
    }
    /// 사용자 위치 정보 업데이트
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLocation = locations.last
        if shouldGetUserLocation {
            MapManager.shared.getLocation(latitude: (lastLocation?.coordinate.latitude)!,
                                          longitude: (lastLocation?.coordinate.longitude)!)
            manager.stopUpdatingLocation()
        }
    }
}
// MARK: - UI
extension MapViewController: BaseViewSettingProtocol {
    func setAddSubViews() {
        view.addSubview(mainMap)
        [cameraButton].forEach {
            mainMap.addSubview($0)
        }
    }
    func setBasics() {
        hideNavigationBar(shouldHide: true)
    }
    func setLayouts() {
        let safeGuide = view.safeAreaLayoutGuide
        let padding: CGFloat = 16
        let buttonSize: CGFloat = 48
        mainMap.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        cameraButton.snp.makeConstraints {
            $0.top.equalTo(safeGuide.snp.top).offset(padding)
            $0.trailing.equalToSuperview().offset(-padding)
            $0.width.height.equalTo(buttonSize)
        }
    }
    func createViews() {
        setAddSubViews()
        setBasics()
        setLayouts()
    }
}
