//
//  HistoryTableViewCell.swift
//  PetrolAcker
//
//  Created by Hansel Matthew on 21/07/22.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var distanceTravelledLabel: UILabel!
    @IBOutlet weak var fuelUsedLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var carNameLabel: UILabel!
    
//    var entry = NSManagedObject()
    
    
    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        
//        guard let tripDate = entry.value(forKey: "tripDate") as? Date,
//              guard let carName = entry.value(forKey: "carName") as? String,
//              let distanceTravelled = entry.value(forKey: "distanceTravelled") as? String,
//              let fuelUsed = entry.value(forKey: "fuelUsed") as? String else {return}
        
//        guard let tripDate = entry.tripDate,
//              let carName = entry.carName else {return}
//        let fuelUsed = entry.fuelUsed
//        let distanceTravelled = entry.distanceTravelled
        
//        dateLabel.text = getStringDate(date: tripDate)
//        carNameLabel.text = carName
//        fuelUsedLabel.text = String(fuelUsed)
//        distanceTravelledLabel.text = String(distanceTravelled)
//
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
//    func getStringDate(date:Date) -> String {
//        let calendar = Calendar.current
//        let year = calendar.component(.year, from: date)
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "LLLL"
//        let month = dateFormatter.string(from: date)
//
//        let day = calendar.component(.day, from: date)
//
//        let time = "\(day) \(month) \(year)"
//
//        return time
//    }
    
}
