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
    
    private var elevationAdjustments: Set<UIViewController> = []
    
    let carSubject = PublishSubject<Car>()
    var carSubjectObservable: Observable<Car>{
        return carSubject.asObservable()
    }
    let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
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
        layoutBottomSheet(configureFuelVC.view)
        present(configureFuelVC,animated: true)
    }
    
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

extension StartTripViewController: UIViewControllerTransitioningDelegate
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
