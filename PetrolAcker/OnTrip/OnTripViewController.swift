//
//  OnTripViewController.swift
//  PetrolAcker
//
//  Created by Hansel Matthew on 21/07/22.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation

@objc protocol OnTripViewControllerDelegate {
    func endTripPressed()
}

class OnTripViewController: UIViewController {
    
    // MARK: - Properties

    @IBOutlet weak var fuelUsedLabel: UILabel!
    @IBOutlet weak var distanceTravelledLabel: UILabel!
    
    weak var delegate: OnTripViewControllerDelegate?
    
    var distanceSubject = PublishSubject<CLLocationDistance>()
    private var distanceSubjectObservables: Observable<CLLocationDistance>{
        return distanceSubject.asObservable()
    }
    private let disposeBag = DisposeBag()
    
    private var distanceTravelled: Double = 0
    private var kmperl = 0
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureData()
        bindDistance()
    }
    
    public init()
    {
        super.init(nibName: "OnTripViewController", bundle: nil)
    }

    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
    }
    
    // MARK: - Functions
    
    func configureData(){
        kmperl = UserDefaultManager.shared.defaults?.value(forKey: "fuelConsumption") as! Int
    }
    
    func bindDistance(){
        distanceSubjectObservables.subscribe(onNext:{ distance in
            
            self.distanceTravelled += Double(distance/1000)
            self.distanceTravelledLabel.text = String("\(self.round1Decimal(self.distanceTravelled)) Km")
            
            let fuelUsed = self.distanceTravelled/Double(self.kmperl)
            self.fuelUsedLabel.text = String("\(self.round1Decimal(fuelUsed)) Liter")
        },onCompleted: {
            print("DEBUG: Completed")
        }).disposed(by: disposeBag)
    }
    
    func round1Decimal(_ number: Double) -> Double{
        return round(number * 10) / 10.0
    }
                                             
    @IBAction func endTripPressed(_ sender: UIButton) {
        
        dismiss(animated: true)
        delegate?.endTripPressed()
        
    }
}
