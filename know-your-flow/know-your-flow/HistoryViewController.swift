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
    var averageLength = 5
    var averageCycle = 28
    
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
                if self.periodHistory.count < 6 {
                    self.topLabel.text = "Averaging your last \(self.periodHistory.count) cycles"
                }
                else {
                    self.topLabel.text = "Averaging your last 6 cycles"
                }
                
            }
            else{
                print("error finding data")
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Add a background view to the table view
        let backgroundImage = UIImage(named: "bg5.jpg")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        
        let preferenceQuery = PFQuery(className: "Preferences")
        preferenceQuery.includeKey("author")
        preferenceQuery.whereKey("author", equalTo: PFUser.current())
        preferenceQuery.findObjectsInBackground{
            (records, error) in
            if(error != nil) {
                print("error quering preferences")
            }else{
                self.periodLengthLabel.text = String(records?[0]["averageDaysinPeriod"] as! Int)
                self.cycleLengthLabel.text = String(records?[0]["averageDaysBtwnPeriod"] as! Int)
            }
        }
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
                    self.recalculateDataAndSave()
                    //TODO: calculate new averages
                    if self.periodHistory.count < 6 {
                        self.topLabel.text = "Averaging your last \(self.periodHistory.count) cycles"
                    }
                    else {
                        self.topLabel.text = "Averaging your last 6 cycles"
                    }
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
    
    
    func recalculateDataAndSave(){
        //update all the cycle and length
        let historyQuery = PFQuery(className: "PeriodHistory")
        historyQuery.includeKey("author")
        historyQuery.whereKey("author", equalTo: PFUser.current())
        historyQuery.findObjectsInBackground {
            (records, error)in
            if(records != nil){
                
                var c = records!.count
                if(c==1){
                    records![0]["daysBetweenPeriod"] = self.averageCycle
                    
                    var newPeriodLength = (records![0]["endDate"] as! Date).timeIntervalSince(records![0]["startDate"] as! Date)
                    records![0]["periodLength"] = Int(newPeriodLength)/60/60/24
                    records![0].saveInBackground{
                        (success, error)in
                        if success {
                            //calculate averages
                            self.averageCycle = self.calcAverageCycle()
                            print(self.averageCycle)
                            
                            //average period length
                            self.averageLength = self.calcAveragePeriodLength()
                            print(self.averageLength)
                            
                            // save to Preference table
                            let queryPreferences = PFQuery(className:"Preferences")
                            queryPreferences.includeKey("author")
                            queryPreferences.whereKey("author", equalTo: PFUser.current() as Any)
                            queryPreferences.findObjectsInBackground {
                                (records, error)in
                                if(records != nil){
                                    records![0]["averageDaysBtwnPeriod"] = self.averageCycle
                                    records![0]["averageDaysinPeriod"] = self.averageLength
                                    self.periodLengthLabel.text = String(records?[0]["averageDaysinPeriod"] as! Int)
                                    self.cycleLengthLabel.text = String(records?[0]["averageDaysBtwnPeriod"] as! Int)
                                    records![0].saveInBackground { (success, error) in
                                        if success{
                                            print("new averages saved")
                                            
                                        }else{
                                            print("error updating preference")
                                        }
                                    }
                                }
                                else{
                                    print("error updating preference ")
                                }
                                
                            }
                            
                        }
                    }
                    self.queryHistory()
                }else if (c>1) {
                    
                    
                    for i in 1...(c-1) {
                        
                        var newCycle = (records![i]["startDate"] as! Date).timeIntervalSince(records![i-1]["startDate"] as! Date)
                        records![i]["daysBetweenPeriod"] = Int(newCycle)/60/60/24
                        var newPeriodLength = (records![i]["endDate"] as! Date).timeIntervalSince(records![i]["startDate"] as! Date)
                        records![i]["periodLength"] = Int(newPeriodLength)/60/60/24
                        records![i].saveInBackground{
                            (success, error)in
                            if success {
                                //calculate averages
                                self.averageCycle = self.calcAverageCycle()
                                print(self.averageCycle)
                                
                                //average period length
                                self.averageLength = self.calcAveragePeriodLength()
                                print(self.averageLength)
                                
                                // save to Preference table
                                let queryPreferences = PFQuery(className:"Preferences")
                                queryPreferences.includeKey("author")
                                queryPreferences.whereKey("author", equalTo: PFUser.current() as Any)
                                queryPreferences.findObjectsInBackground {
                                    (records, error)in
                                    if(records != nil){
                                        records![0]["averageDaysBtwnPeriod"] = self.averageCycle
                                        records![0]["averageDaysinPeriod"] = self.averageLength
                                        self.periodLengthLabel.text = String(records?[0]["averageDaysinPeriod"] as! Int)
                                        self.cycleLengthLabel.text = String(records?[0]["averageDaysBtwnPeriod"] as! Int)
                                        records![0].saveInBackground { (success, error) in
                                            if success{
                                                print("new averages saved")
                                                
                                            }else{
                                                print("error updating preference")
                                            }
                                        }
                                    }
                                    else{
                                        print("error updating preference ")
                                    }
                                    
                                }
                                
                            }
                        }
                        self.queryHistory()
                    }
                }
                
            }else{
                print("error loading period history")
            }
            
            
        }
        
        
    }
    
    func calcAverageCycle() -> Int{
        
        //TODO: handle new entry is in between data
        //if count < 6, then add differences of what we have, devided by count.
        var total = 0
        let count = self.periodHistory.count
        if( count < 6){
            for period in self.periodHistory {
                total += (period["daysBetweenPeriod"] as! Int)
            }
            
            return Int(total / count)
        }
        else{
            //else: add the differences of the last 6, devide by 6
            var counter = 6
            while(counter > 0){
                total += self.periodHistory[counter - 1]["daysBetweenPeriod"] as! Int
                counter -= 1
            }
            
            return Int(total / 6)
            
        }
        
    }
    
    func calcAveragePeriodLength() -> Int{
        
        //TODO: handle new entry is in between data
        //if count < 6, then add differences of what we have, devided by count.
        var total = 0
        let count = self.periodHistory.count
        if(count < 6){
            for period in self.periodHistory {
                total += (period["periodLength"] as! Int)
            }
            
            return Int(total / count)
        }
        else{
            //else: add the differences of the last 6, devide by 6
            var counter = 6
            while(counter > 0){
                total += self.periodHistory[counter - 1]["periodLength"] as! Int
                counter -= 1
            }
            
            return Int(total / 6)
            
        }
        
    }
    
    func queryHistory(){
        let query = PFQuery(className: "PeriodHistory")
        query.includeKey("author")
        query.whereKey("author", equalTo: PFUser.current())
        query.order(byAscending: "startDate")
        query.findObjectsInBackground{
            (records, error) in
            if records != nil {
                self.periodHistory = records!
                
            }
        }
    }
    
    
}
