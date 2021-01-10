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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationErrorCheck()
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
    // 위치 서비스 인증 상태 에러 처리
    private func locationErrorCheck() {
        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.authorizationStatus() == .denied ||
                CLLocationManager.authorizationStatus() == .restricted {
                print("위치 서비스 기능이 꺼져있음")
            } else {
                userLocationManager.desiredAccuracy = kCLLocationAccuracyBest
                userLocationManager.delegate = self
                userLocationManager.requestWhenInUseAuthorization()
                userLocationManager.requestAlwaysAuthorization()
            }
        } else {
            print("위치 서비스 제공 불가")
        }
    }
    /// 위도 경도 값 가져오기
    private func getLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let findLocation = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        geocoder.reverseGeocodeLocation(findLocation, preferredLocale: locale) { (placemarks, _) in
            if let address: [CLPlacemark] = placemarks {
                var myAddress: String = ""
                if let area: String = address.last?.locality {
                    myAddress += area
                }
                if let name: String = address.last?.name {
                    myAddress += " "
                    myAddress += name
                }
            }
        }
    }
}
// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    /// 위치 허용 선택 시 처리
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("didChangeAuthorization notDetermined")
            manager.requestAlwaysAuthorization()
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            print("didChangeAuthorization authorizedWhenInUse authorizedAlways")
        case .restricted:
            print("didChangeAuthorization restricted")
        case .denied:
            print("didChangeAuthorization denied")
        default:
            break
        }
    }
    /// 사용자 위치 정보 업데이트
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLocation = locations.last
        if shouldGetUserLocation {
            print(getLocation(latitude: (lastLocation?.coordinate.latitude)!,
                              longitude: (lastLocation?.coordinate.longitude)!))
        }
    }
}
// MARK: - UI
extension MapViewController: BaseViewSettingProtocol {
    func defaultSettingNavigation() {
        navigationController?.navigationBar.isHidden = true
    }
    func setAddSubViews() {
        view.addSubview(mainMap)
        [cameraButton].forEach {
            mainMap.addSubview($0)
        }
    }
    func setBasics() {
        defaultSettingNavigation()
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
