//
//  StartTripViewController.swift
//  PetrolAcker
//
//  Created by Hansel Matthew on 21/07/22.
//

import UIKit
import RxSwift

@objc protocol StartTripViewControllerDelegate {
    func startTripPressed()
}

class StartTripViewController: UIViewController {
    
    
    // MARK: - Properties
    @IBOutlet weak var carSpecificationButton: UIButton!
    @IBOutlet weak var fuelTankImageView: UIImageView!
    @IBOutlet weak var historyButton: UIButton!
    
    weak var delegate: StartTripViewControllerDelegate?
    
    let carSubject = PublishSubject<Car>()
    var carSubjectObservable: Observable<Car>{
        return carSubject.asObservable()
    }
    let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("DEBUG: 1")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("DEBUG: 2")
    }
    
    public init()
    {
        super.init(nibName: "StartTripViewController", bundle: nil)
    }

    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
    }
    
    // MARK: - Functions
    func configureData(){
        let carName = (UserDefaultManager.shared.defaults?.value(forKey: "carName") as? String) ?? "Configure Here"
        carSpecificationButton.setTitle("  \(carName)", for: .normal)
    }
    
    @IBAction func startTripPressed(_ sender: UIButton) {
        dismiss(animated: true)
        delegate?.startTripPressed()
    }
    
    @IBAction func carSpecificationPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "CarSpecification", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "CarSpecificationViewController") as? CarSpecificationViewController else {return}
        
        vc.carSubjectObservable.subscribe(onNext:{ [unowned self] car in
            
            UserDefaultManager.shared.defaults?.set(car.carName, forKey: "carName")
            UserDefaultManager.shared.defaults?.set(car.fuelConsumption, forKey: "fuelConsumption")
            UserDefaultManager.shared.defaults?.set(car.fuelTankCapacity, forKey: "fuelTankCapacity")
            
            self.carSpecificationButton.setTitle("  \(car.carName)", for: .normal)
        }).disposed(by: disposeBag)
        present(vc,animated: true)
    }
    
    @IBAction func historyButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "History", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HistoryViewController")
        present(vc,animated: true)
    }
}
