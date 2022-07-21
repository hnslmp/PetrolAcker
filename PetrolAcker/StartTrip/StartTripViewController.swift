//
//  StartTripViewController.swift
//  PetrolAcker
//
//  Created by Hansel Matthew on 21/07/22.
//

import UIKit

@objc protocol StartTripViewControllerDelegate {
    func startTripPressed()
}

class StartTripViewController: UIViewController {
    
    

    @IBOutlet weak var carSpecificationButton: UIButton!
    @IBOutlet weak var fuelTankImageView: UIImageView!
    @IBOutlet weak var historyButton: UIButton!
    
    weak var delegate: StartTripViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public init()
    {
        super.init(nibName: "StartTripViewController", bundle: nil)
    }

    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
    }
    
    @IBAction func startTripPressed(_ sender: UIButton) {
        dismiss(animated: true)
        delegate?.startTripPressed()
    }
    
    @IBAction func carSpecificationPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "CarSpecification", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CarSpecificationViewController")
        present(vc,animated: true)
    }
    
    @IBAction func historyButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "History", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HistoryViewController")
        present(vc,animated: true)
    }
}
