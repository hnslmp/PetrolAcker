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
    @IBOutlet weak var carNameFieldRequiredLabel: UILabel!
    @IBOutlet weak var fuelConsumptionFieldRequiredLabel: UILabel!
    @IBOutlet weak var fuelTankFieldRequiredLabel: UILabel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 

    }
    
    // MARK: - Functions
    
    func checkTextFieldNotEmpty() -> Bool{
        
        var fieldFlag: Bool = true
        
        if carNameTextField.text?.isEmpty == true {
            print("DEBUG: Car name empty")
            carNameFieldRequiredLabel.isHidden = false
            carNameFieldRequiredLabel.shake()
            fieldFlag = false
        }else{
            carNameFieldRequiredLabel.isHidden = true
        }
        
        if fuelTankCapacityTextField.text?.isEmpty == true {
            print("DEBUG: Fuel tank empty")
            fuelTankFieldRequiredLabel.isHidden = false
            fuelTankFieldRequiredLabel.shake()
            fieldFlag = false
        }else{
            fuelTankFieldRequiredLabel.isHidden = true
        }
        
        if fuelConsumptionTextField.text?.isEmpty == true {
            print("DEBUG: Fuel Consumption empty")
            fuelConsumptionFieldRequiredLabel.isHidden = false
            fuelConsumptionFieldRequiredLabel.shake()
            fieldFlag = false
        }else{
            fuelConsumptionFieldRequiredLabel.isHidden = true
        }
        
        return fieldFlag
        
        
    
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        if checkTextFieldNotEmpty() {
            guard let carName = carNameTextField.text else {return}
            guard let fuelConsumption = fuelConsumptionTextField.text else {return}
            guard let fuelTankCapacity = fuelTankCapacityTextField.text else {return}
            
            let car = Car(carName: carName, fuelConsumption: Int(fuelConsumption)!, fuelTankCapacity: Int(fuelTankCapacity)!)
            
            carSubject.onNext(car)
            
            dismiss(animated: true)
            
        }
        
        
    }
}
