//
//  CarSpecificationViewController.swift
//  PetrolAcker
//
//  Created by Hansel Matthew on 21/07/22.
//

import UIKit
import RxSwift

class CarSpecificationViewController: UIViewController {

    
    // MARK: - Properties
    
    private let carSubject = PublishSubject<Car>()
    
    var carSubjectObservable: Observable<Car>{
        return carSubject.asObservable()
    }
    
    @IBOutlet weak var carNameTextField: UITextField!
    @IBOutlet weak var fuelConsumptionTextField: UITextField!
    @IBOutlet weak var fuelTankCapacityTextField: UITextField!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Functions
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        guard let carName = carNameTextField.text else {return}
        guard let fuelConsumption = fuelConsumptionTextField.text else {return}
        guard let fuelTankCapacity = fuelTankCapacityTextField.text else {return}
        
        let car = Car(carName: carName, fuelConsumption: Int(fuelConsumption)!, fuelTankCapacity: Int(fuelTankCapacity)!)
        carSubject.onNext(car)
    
        dismiss(animated: true)
    }
}
