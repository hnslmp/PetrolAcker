//
//  ConfigureFuelViewController.swift
//  PetrolAcker
//
//  Created by Hansel Matthew on 21/07/22.
//

import UIKit
import RxSwift

class ConfigureFuelViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var fuelLabel: UILabel!
    @IBOutlet weak var fuelSlider: UISlider!
    
    private let fuelSubject = PublishSubject<Float>()
    
    private var fuelSubjectObservable: Observable<Float>{
        return fuelSubject.asObservable()
    }
    
    private let startScreenFuelSubject = PublishSubject<Float>()
    
    var startScreenFuelSubjectObservable: Observable<Float>{
        return startScreenFuelSubject.asObservable()
    }
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureData()
        bindFuel()
    }
    
    public init()
    {
        super.init(nibName: "ConfigureFuelViewController", bundle: nil)
    }

    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
    }
    
    // MARK: - Functions
    func configureData(){
        
        guard let fuelStatus = UserDefaultManager.shared.defaults?.value(forKey: "fuelStatus") as? Float else {return}
        fuelSlider.value = fuelStatus
        fuelLabel.text = "\(Int(fuelStatus))%"
       
    }
    
    func bindFuel(){
        fuelSubjectObservable.subscribe(onNext:{ [unowned self] fuel in
            let intFuel = Int(fuel)
            self.fuelLabel.text = "\(intFuel)%"
        }).disposed(by: disposeBag)
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        let sliderValue = sender.value
        fuelSubject.onNext(sliderValue)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        let sliderFuelStatus = fuelSlider.value
        UserDefaultManager.shared.defaults?.set(sliderFuelStatus, forKey: "fuelStatus")
        startScreenFuelSubject.onNext(sliderFuelStatus)
        
        dismiss(animated: true)
    }
}
