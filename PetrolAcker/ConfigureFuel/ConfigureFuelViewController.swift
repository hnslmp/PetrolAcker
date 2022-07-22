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
    
    var fuelSubjectObservable: Observable<Float>{
        return fuelSubject.asObservable()
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
        let fuelStatus = UserDefaultManager.shared.defaults?.value(forKey: "fuelStatus") ?? 0
        fuelSlider.value = fuelStatus as? Float ?? 0
        fuelLabel.text = "\(fuelStatus)%"
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
        
        let intFuel = Int(fuelSlider.value)
        UserDefaultManager.shared.defaults?.set(intFuel, forKey: "fuelStatus")
        
        dismiss(animated: true)
    }
}
