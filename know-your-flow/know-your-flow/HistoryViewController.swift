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
    
    
    @IBOutlet weak var boxview: UIView!
    @IBOutlet weak var topLabel: UILabel!
    
    @IBOutlet weak var cycleLengthLabel: UILabel!
    @IBOutlet weak var periodLengthLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
   
    
    let dateFormatter = DateFormatter()
    var periodHistory = [PFObject]()
  

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
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
                
                let firstRecord = records?.first
                
                //will crash if no data
                if firstRecord != nil {
                    self.cycleLengthLabel.text = "\((firstRecord?["averageCycle"])!)"
                    self.periodLengthLabel.text = "\((firstRecord?["averagePeriodLength"])!)"
                }
                else {
                    self.cycleLengthLabel.text = "0"
                    self.periodLengthLabel.text = "0"
                }
                
            }
            if self.periodHistory.count < 6 {
                self.topLabel.text = "Averaging your last \(self.periodHistory.count) cycles"
            }
            else {
                self.topLabel.text = "Averaging your last 6 cycles"
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Add a background view to the table view
        let backgroundImage = UIImage(named: "bg5.jpg")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView

    }
    
    //TABLE VIEW STUFF
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return periodHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PeriodHistoryCell") as! PeriodHistoryCell
        
        //transparent cell
        cell.backgroundColor = UIColor(white: 1, alpha: 0.7)
        
        let history = periodHistory[indexPath.row]
        
        //first day label
        self.dateFormatter.dateFormat = "MMM d, yyyy"
        cell.firstDayLabel.text = self.dateFormatter.string(for: history["startDate"])
        
        //length label
        cell.lengthLabel.text = "\((history["periodLength"])!)"
        
        //cycle label
        cell.cycleLabel.text = "\((history["daysBetweenPeriod"])!)"
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
