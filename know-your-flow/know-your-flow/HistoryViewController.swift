//
//  HistoryViewController.swift
//  know-your-flow
//
//  Created by Sophia Sun on 5/8/19.
//  Copyright © 2019 debbienvo. All rights reserved.
//

import UIKit
import Parse

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var LastPeriodLabel: UILabel!
    
    let dateFormatter = DateFormatter()
    var periodHistory = [PFObject]()
  

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        //navigationItem.rightBarButtonItem = editButtonItem
        
        
      
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let query = PFQuery(className: "PeriodHistory")
        query.includeKey("author")
        query.whereKey("author", equalTo: PFUser.current())
        query.order(byDescending: "startDate")
        query.findObjectsInBackground{
            (records, error) in
            if records != nil {
                self.periodHistory = records!
                self.tableView.reloadData()
                
                // this is for displaying last date
                let firstRecord = records?.first
                self.dateFormatter.dateFormat = "MMM d, yyyy"
                let lastStartDate = self.dateFormatter.string(for: firstRecord?["startDate"])
                let lastEndDate = self.dateFormatter.string(for: firstRecord?["endDate"])
                //print(lastDate)
                self.LastPeriodLabel.text =  "\(lastStartDate ?? "no record found") - \(lastEndDate ?? "no record found")"
                
            }
        }
        
    }
    
    //TABLE VIEW STUFF
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return periodHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeriodHistoryCell") as! PeriodHistoryCell
        let history = periodHistory[indexPath.row]
        
        self.dateFormatter.dateFormat = "MMM d, yyyy"
        cell.firstDayLabel.text = self.dateFormatter.string(for: history["startDate"])
        //cell.lengthLabel.text = history["periodLength"] as? String
        return cell
    }
    
    //Delete Cell/Period
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            let selectedHistory = periodHistory[indexPath.section]
            selectedHistory.deleteInBackground()
            periodHistory.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            selectedHistory.saveInBackground { (success, error) in
                if success {
                    print("deleted")
                }
                else {
                    print("Error deleting")
                }
            }
            
            

        }
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let period = periodHistory[indexPath.row]
        
        //print(period)
        
        let detailsViewController = segue.destination as! PeriodDetailViewController
        
        detailsViewController.period = period
        tableView.deselectRow(at: indexPath, animated: true)
     
    }
 

}
