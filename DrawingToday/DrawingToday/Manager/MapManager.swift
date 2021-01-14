//
//  MapManager.swift
//  DrawingToday
//
//  Created by 이진욱 on 2021/01/13.
//

import MapKit

class MapManager {
    // MARK: - Properties
    static let shared = MapManager()
    // MARK: - Init
    private init() {}
    // MARK: - Func
    // 위치 서비스 인증 상태 에러 처리
    func locationErrorCheck(locationManager: CLLocationManager) {
        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.authorizationStatus() == .denied ||
                CLLocationManager.authorizationStatus() == .restricted {
                print("위치 서비스 기능이 꺼져있음")
            } else {
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.requestWhenInUseAuthorization()
                locationManager.requestAlwaysAuthorization()
            }
        } else {
            print("위치 서비스 제공 불가")
        }
    }
    /// 위도 경도 값 가져오기
    func getLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
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
                print("myAddress : ", myAddress)
            }
        }
    }
    /// 위치 허용 선택 시 처리
    func locationAllowSet(locationManager: CLLocationManager, status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("didChangeAuthorization notDetermined")
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
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
}
