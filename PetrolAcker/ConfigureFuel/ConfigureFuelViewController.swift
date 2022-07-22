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
    
    private let fuelSubject = PublishSubject<Int>()
    
    var fuelSubjectObservable: Observable<Int>{
        return fuelSubject.asObservable()
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        dismiss(animated: true)
    }
}
