//
//  ViewController.swift
//  PetrolAcker
//
//  Created by Hansel Matthew on 19/07/22.
//

import UIKit
import MapKit
import CoreLocation
import RxSwift

class MapViewController: UIViewController{
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Properties
    
    private var prevlocation: CLLocation?
        
    private let distanceSubject = PublishSubject<CLLocationDistance>()

    private var distanceSubjectObservables: Observable<CLLocationDistance>{
        return distanceSubject.asObservable()
    }
    
    private let locationManager = CLLocationManager()
    private let regionInMeter:Double = 10000
    private var elevationAdjustments: Set<UIViewController> = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        presentStartTripVC()
    }
    
    func presentStartTripVC(){
        let startTripVC = StartTripViewController()
        startTripVC.transitioningDelegate = self
        startTripVC.delegate = self
        startTripVC.modalPresentationStyle = .custom
        layoutBottomSheet(startTripVC.view)
        present(startTripVC, animated: true)
    }
    
    func presentOnTripVC(){
        let onTripVC = OnTripViewController()
        onTripVC.transitioningDelegate = self
        onTripVC.delegate = self
        
        onTripVC.distanceSubject = distanceSubject
        
        onTripVC.modalPresentationStyle = .custom
        layoutBottomSheet(onTripVC.view)
        present(onTripVC, animated: true)
    }
    
    // MARK: - Functions
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManager()
            configureMapView()
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
    
    func configureMapView(){
        locationManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
    }
    
}

// MARK: - Extensions

extension MapViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        
        let prevvLocation = prevlocation ?? location
        let distance = location.distance(from: prevvLocation)
        distanceSubject.onNext(distance)
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude - 0.03, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeter, longitudinalMeters: regionInMeter)
        mapView.setRegion(region, animated: true)
        prevlocation = location
        
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
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

extension MapViewController: StartTripViewControllerDelegate{
    
    func startTripPressed() {
        presentOnTripVC()
    }
}

extension MapViewController: OnTripViewControllerDelegate{
    
    func endTripPressed() {
        presentStartTripVC()
    }
}
