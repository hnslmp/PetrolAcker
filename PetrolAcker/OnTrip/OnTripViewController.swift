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
import CoreData

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
    private var disposeBag = DisposeBag()
    
    private var distanceTravelled: Double = 0
    private var fuelUsed: Double = 0
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
        //Mapkit data subscriber
        distanceSubjectObservables.subscribe(onNext:{ [unowned self] distance in
            
            self.distanceTravelled += Double(distance/1000)
            self.distanceTravelledLabel.text = String("\(self.round1Decimal(self.distanceTravelled)) Km")
            
            self.fuelUsed = self.distanceTravelled/Double(self.kmperl)
            self.fuelUsedLabel.text = String("\(self.round1Decimal(self.fuelUsed)) Liter")
            
            

            
        }).disposed(by: disposeBag)
    }
    
    func round1Decimal(_ number: Double) -> Double{
        return round(number * 10) / 10.0
    }
    
    func configFuelStatus(){
        let fuelStatus = UserDefaultManager.shared.defaults?.value(forKey: "fuelStatus") as! Float
        let fuelTankCapacity = UserDefaultManager.shared.defaults?.value(forKey: "fuelTankCapacity") as! Double
        let fuelConsumedPercent = self.fuelUsed/fuelTankCapacity*100
        let fuelNow = fuelStatus - Float(fuelConsumedPercent)
        
        print("DEBUG: Fuel now \(fuelNow)")
        UserDefaultManager.shared.defaults?.set(fuelNow, forKey: "fuelStatus")
    }
    
    func endTripAlert(){
        let alert = UIAlertController(
            title: "End Trip?",
            message: "Are you sure you want to end the trip?",
            preferredStyle: .alert
        )

        alert.view.tintColor = UIColor(named: "MidnightBlue")

        //Yes Choice
        alert.addAction(UIAlertAction(
            title: "End Trip",
            style: .default,
            handler: { action in
                self.configFuelStatus()
                self.saveTrip()
                self.dismiss(animated: true)
                self.delegate?.endTripPressed()
            })
        )
        
        //Cancel Choice
        alert.addAction(UIAlertAction(
            title: "Cancel",
            style: .destructive,
            handler: { action in
            })
        )
        
        
        
        present(alert, animated: true)
    }
    
    func saveTrip(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        guard let carName = UserDefaultManager.shared.defaults?.value(forKey: "carName") as? String else {return}
        
        let newEntry = Entries(context: context)
        
        newEntry.carName = carName
        newEntry.fuelUsed = round1Decimal(self.fuelUsed)
        newEntry.distanceTravelled = round1Decimal(self.distanceTravelled)
        newEntry.tripDate = Date()
        
        do{
            try context.save()
            print("DEBUG: Succesfully saved data to coredata")
        }catch{
            print("DEBUG: Error saving to coredata")
        }
        
        disposeBag = DisposeBag()
    }
                                             
    @IBAction func endTripPressed(_ sender: UIButton) {
        endTripAlert()
    }
}
