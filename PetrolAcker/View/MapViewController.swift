//
//  ViewController.swift
//  PetrolAcker
//
//  Created by Hansel Matthew on 19/07/22.
//

import UIKit
import MapKit
import CoreLocation

func layoutBottomSheet(_ view: UIView)
{
    view.backgroundColor        = .systemBackground
    view.layer.cornerRadius     = 20
    view.layer.maskedCorners    = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
}

class MapViewController: UIViewController{
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Properties
    
    
    private let locationManager = CLLocationManager()
    private let regionInMeter:Double = 10000
    private var elevationAdjustments: Set<UIViewController> = []
    
    private let startTripVC: StartTripViewController = {
        let vc = StartTripViewController()
        vc.modalPresentationStyle = .custom
        layoutBottomSheet(vc.view)
        return vc
    }()
    
    private let onTripVC : OnTripViewController = {
        let vc = OnTripViewController()
        vc.modalPresentationStyle = .custom
        layoutBottomSheet(vc.view)
        return vc
    }()
    
    

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        
        startTripVC.transitioningDelegate = self
        onTripVC.transitioningDelegate = self
        
        
        super.viewDidLoad()
        present(onTripVC, animated: true)
        checkLocationServices()

    }
    
    // MARK: - Functions
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManager()
            checkLocationAuthorization()
        }
        else{
            
        }
    }
    
    func centerViewOnUserLocation(){
        if let location = locationManager.location?.coordinate{
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeter, longitudinalMeters: regionInMeter)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            break
        case .authorizedAlways:
            break
        }
    }
    
}

// MARK: - Extensions

extension MapViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeter, longitudinalMeters: regionInMeter)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        //todo
    }
}

extension MapViewController: UIViewControllerTransitioningDelegate
{
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController?
    {
        let pc = SheetPresentationController(
            presentedViewController: presented,
            presenting: presenting
        )
        let insertion = elevationAdjustments.insert(presented)
        // only elevate when vc was previously not in the set
        pc.isNeedElevation = insertion.inserted
        return pc
    }
}
