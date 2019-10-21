//
//  UserLocationViewController.swift
//  TestWeather
//
//  Created by Газияв Исхаков on 20.10.2019.
//  Copyright © 2019 Газияв Исхаков. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol UserDidChooseLocationDelegate: class {
    func addLocation(for city: CityName)
}

class UserLocationViewController: UIViewController {
    
    weak var delegate: UserDidChooseLocationDelegate?
    
    private var locationManager = CLLocationManager()
    private let regionInMeters: Double = 10000
    
    private var previousLocation = CLLocation()
    
    private var choosenCityInformation: CityName?
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 26)
        return label
    }()
    
    private let pin: UIImageView = {
        let image = UIImage(named: "MapPin")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let map: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let doneButton = UIBarButtonItem(image: UIImage(named: "Done"), style: .plain, target: self, action: #selector(doneButtonAction))
        navigationItem.rightBarButtonItem = doneButton
        setupMapView()
        checkServices()
    }
    
    @objc private func doneButtonAction() {
        if let choosenCity = choosenCityInformation {
        delegate?.addLocation(for: choosenCity)
        }
        self.navigationController?.popViewController(animated: true)
        locationManager.stopUpdatingLocation()
    }
    

    private func setupMapView() {
        view.addSubview(map)
        
        map.delegate = self
        
        NSLayoutConstraint.activate([
            map.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            map.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            map.topAnchor.constraint(equalTo: view.topAnchor),
            map.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        setupPin()
        setupLabel()
    }
    
    private func setupLabel() {
        map.addSubview(cityLabel)
        NSLayoutConstraint.activate([
            cityLabel.centerXAnchor.constraint(equalTo: map.centerXAnchor),
            cityLabel.topAnchor.constraint(equalTo: map.topAnchor, constant: 150)
        ])
    }
    
    private func setupPin() {
        map.addSubview(pin)
        
        NSLayoutConstraint.activate([
            pin.centerXAnchor.constraint(equalTo: map.centerXAnchor),
            pin.heightAnchor.constraint(equalToConstant: 40),
            pin.widthAnchor.constraint(equalToConstant: 40),
            pin.centerYAnchor.constraint(equalTo: map.centerYAnchor)
        ])
    }
    
    private func checkServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            print("hello there")
        }
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    private func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .authorizedWhenInUse:
            startTracking()
        case .authorizedAlways:
            break
        @unknown default:
            break
        }
    }
    
    private func startTracking() {
        locationManager.startUpdatingLocation()
        map.showsUserLocation = true
        centerUserLocation()
        previousLocation = getCenterLocation(for: map)
    }
    
    private func centerUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            map.setRegion(region, animated: true)
        }
    }
    
    private func getCenterLocation(for map: MKMapView) -> CLLocation {
        let latitude = map.centerCoordinate.latitude
        let longitude = map.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}

extension UserLocationViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        centerUserLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

extension UserLocationViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        let geoCoder = CLGeocoder()
        
        guard center.distance(from: previousLocation) > 50 else { return }
        previousLocation = center
        
        geoCoder.reverseGeocodeLocation(center) { [unowned self] (placemarks, error) in
            
            if let _ = error {
                self.cityLabel.text = "Unowned"
                return
            }
            
            guard let placemark = placemarks?.first else { return }
           
            guard let city = placemark.locality, let country = placemark.country, let countryCode = placemark.isoCountryCode else { return }
            
            DispatchQueue.main.async {
                self.cityLabel.text = city + ", " + country
                self.choosenCityInformation = CityName(name: city, country: country, countryCode: countryCode)
            }
        }
    }
}
