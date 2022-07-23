//
//  HistoryViewController.swift
//  PetrolAcker
//
//  Created by Hansel Matthew on 21/07/22.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var entries:[NSManagedObject] = []
    
    let context = (UIApplication.self.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "Entries")
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "HistoryTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "HistoryTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        do {
            entries = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as! HistoryTableViewCell
        
        let entry = entries[indexPath.row]
        
        let carName = entry.value(forKey: "carName") as? String
        let date = entry.value(forKey: "tripDate") as? Date
        let stringDate = getStringDate(date: date!)
        let distanceTravelled = entry.value(forKey: "distanceTravelled") as? Double ?? 0.0
        let fuelUsed = entry.value(forKey: "fuelUsed") as? Double ?? 0.0
                
        cell.carNameLabel.text = carName
        cell.dateLabel.text = stringDate
        cell.distanceTravelledLabel.text = "\(distanceTravelled) Km"
        cell.fuelUsedLabel.text = "\(fuelUsed) Liter"
        
        return cell
    }
    

    @IBAction func doneButtonPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func getStringDate(date:Date) -> String {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let month = dateFormatter.string(from: date)

        let day = calendar.component(.day, from: date)

        let time = "\(day) \(month) \(year)"

        return time
    }
}
