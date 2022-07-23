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
    @IBOutlet weak var fuelTankLabel: UILabel!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var approxKmLabel: UILabel!
    
    weak var delegate: StartTripViewControllerDelegate?
    private var elevationAdjustments: Set<UIViewController> = []
    
    let carSubject = PublishSubject<Car>()
    var carSubjectObservable: Observable<Car>{
        return carSubject.asObservable()
    }
    
    private let fuelSubject = PublishSubject<Float>()
    var fuelSubjectObservable: Observable<Float>{
        return fuelSubject.asObservable()
    }
    
    let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        print("DEBUG: StartTripViewDidLoad")
        super.viewDidLoad()
        configureData()
        addFuelTankGesture()
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

    func addFuelTankGesture(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(fuelTapped(tapGestureRecognizer:)))
        fuelTankImageView.isUserInteractionEnabled = true
        fuelTankImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func fuelTapped(tapGestureRecognizer: UITapGestureRecognizer){
        let configureFuelVC = ConfigureFuelViewController()
        configureFuelVC.transitioningDelegate = self
        configureFuelVC.modalPresentationStyle = .custom
        
        configureFuelVC.fuelSubjectObservable.subscribe(onNext:{ [unowned self] fuel in
            fuelTankLabel.text = "\(Int(fuel))%"
        }).disposed(by: disposeBag)
        
        layoutBottomSheet(configureFuelVC.view)
        present(configureFuelVC,animated: true)
    }
    
    func configureData(){
        let carName = (UserDefaultManager.shared.defaults?.value(forKey: "carName") as? String) ?? "Configure Here"
        carSpecificationButton.setTitle("  \(carName)", for: .normal)
                
        let fuelStatus = (UserDefaultManager.shared.defaults?.value(forKey: "fuelStatus") as? Double) ?? 0
        fuelTankLabel.text = "\(fuelStatus)%"
        
        let fuelConsumption = UserDefaultManager.shared.defaults?.value(forKey: "fuelConsumption") as? Int ?? 0
        let fuelTankCapacity = UserDefaultManager.shared.defaults?.value(forKey: "fuelTankCapacity") as? Int ?? 0
        
        let fuelRange = Int(fuelConsumption*fuelTankCapacity*Int(fuelStatus)/100)
        approxKmLabel.text = "\(fuelRange) Km"
    }
        
    func showConfigEmptyAlert() {
        let alert = UIAlertController(
            title: "Car Configuration Empty",
            message: "Please configure your car specification first",
            preferredStyle: .alert
        )

        alert.view.tintColor = UIColor(named: "MidnightBlue")
        
        alert.addAction(UIAlertAction(
            title: "Okay will do",
            style: .default,
            handler: { action in
            })
        )

        present(alert, animated: true)
    }
    
    @IBAction func startTripPressed(_ sender: UIButton) {
        if let carName = UserDefaultManager.shared.defaults?.value(forKey: "carName"),
           let fuelConsumption = UserDefaultManager.shared.defaults?.value(forKey: "fuelConsumption"),
           let fuelTankCapacity = UserDefaultManager.shared.defaults?.value(forKey: "fuelTankCapacity"){
            dismiss(animated: true)
            delegate?.startTripPressed()
        }else{
            showConfigEmptyAlert()
        }
        

    }
    
    @IBAction func carSpecificationPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "CarSpecification", bundle: nil)
        guard let carSpecVC = storyboard.instantiateViewController(withIdentifier: "CarSpecificationViewController") as? CarSpecificationViewController else {return}
        
        carSpecVC.carSubjectObservable.subscribe(onNext:{ [unowned self] car in
            UserDefaultManager.shared.defaults?.set(car.carName, forKey: "carName")
            UserDefaultManager.shared.defaults?.set(car.fuelConsumption, forKey: "fuelConsumption")
            UserDefaultManager.shared.defaults?.set(car.fuelTankCapacity, forKey: "fuelTankCapacity")
            self.carSpecificationButton.setTitle("  \(car.carName)", for: .normal)
        }).disposed(by: disposeBag)
        
        present(carSpecVC,animated: true)
    }
    
    @IBAction func historyButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "History", bundle: nil)
        let historyVC = storyboard.instantiateViewController(withIdentifier: "HistoryViewController")
        present(historyVC,animated: true)
    }
}

extension StartTripViewController: UIViewControllerTransitioningDelegate
{
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController?
    {
        let pc = SheetPresentationController(
            presentedViewController: presented,
            presenting: presenting
        )
        let insertion = elevationAdjustments.insert(presented)
        // Only elevate when vc was previously not in the set
        pc.isNeedElevation = insertion.inserted
        return pc
    }
}
