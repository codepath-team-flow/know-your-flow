//
//  PeriodDetailViewController.swift
//  know-your-flow
//
//  Created by Sophia Sun on 5/13/19.
//  Copyright © 2019 debbienvo. All rights reserved.
//

import UIKit
import Parse

class PeriodDetailViewController: UIViewController {
    
    @IBOutlet weak var startDateTextField: UITextField!
    
    @IBOutlet weak var endDateTextField: UITextField!
    
    private var datePicker1: UIDatePicker!
    private var datePicker2: UIDatePicker!
    var periodHistory = [PFObject]()
    var averageLength = 5
    var averageCycle = 28
    var period : PFObject!
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAverageLength()
        getAverageDaysinPeriod()
        dateFormatter.dateFormat = "MMM d, yyyy"
        startDateTextField.text =  dateFormatter.string(from: period!["startDate"] as! Date)
        endDateTextField.text =  dateFormatter.string(from: period!["endDate"] as! Date)
        //print(period.objectId)
        // Do any additional setup after loading the view.
        datePicker1 = UIDatePicker()
        datePicker2 = UIDatePicker()
        datePicker1?.date = period!["startDate"] as! Date
        datePicker1?.datePickerMode = .date
        datePicker1?.addTarget(self, action: #selector(PeriodDetailViewController.startDateChanged(datePicker:)), for: .valueChanged)
        datePicker2?.date = period!["endDate"] as! Date
        datePicker2?.datePickerMode = .date
        
        datePicker2?.addTarget(self, action: #selector(PeriodDetailViewController.endDateChanged(datePicker:)), for: .valueChanged)
        startDateTextField.inputView = datePicker1
        endDateTextField.inputView = datePicker2
        
        queryHistory()
    }
    
    @objc func startDateChanged(datePicker: UIDatePicker){
        dateFormatter.dateFormat = "MMM d, yyyy"
        startDateTextField.text = dateFormatter.string(from: datePicker.date)
        
        //print(datePicker.date)
        
        //dateString = StartDateLabel.text
    }
    @objc func endDateChanged(datePicker: UIDatePicker){
        dateFormatter.dateFormat = "MMM d, yyyy"
        endDateTextField.text = dateFormatter.string(from: datePicker.date)
        
        //print(datePicker.date)
        
        //dateString = StartDateLabel.text
    }
    @IBAction func onSubmitButton(_ sender: Any) {
        
        
        let query = PFQuery(className:"PeriodHistory")
        let objectId = self.period.objectId
        
        query.getObjectInBackground(withId: objectId as! String) { (period: PFObject?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else if let record = period {
                self.dateFormatter.dateFormat = "MMM d, yyyy"
                record["startDate"] = self.dateFormatter.date(from : self.startDateTextField.text!)
                record["endDate"] = self.dateFormatter.date(from : self.endDateTextField.text!)
                record["periodLength"] = Int((record["endDate"] as! Date).timeIntervalSince(record["startDate"] as! Date)/60/60/24)
                
                
                period!.saveInBackground { (success, error) in
                    if success{
                        print("period edited and saved")
                        
                    }else{
                        print("error editing period")
                    }
                }
                
                self.queryHistory()
                
                period!.saveInBackground { (success, error) in
                    if success{
                        self.queryHistory()
                        self.recalculateDataAndSave()
                        print("period edited and saved")
                        
                    }else{
                        print("error editing period")
                    }
                }
            }
        }
        
        
        
    }
    
    
    
    
    @IBAction func onBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func recalculateDataAndSave(){
        //update all the cycle and length
        let historyQuery = PFQuery(className: "PeriodHistory")
        historyQuery.includeKey("author")
        historyQuery.whereKey("author", equalTo: PFUser.current())
        historyQuery.order(byAscending: "startDate")
        historyQuery.findObjectsInBackground {
            (records, error)in
            if(records != nil){
                
                var c = records!.count
                if(c==1){
                    records![0]["daysBetweenPeriod"] = self.averageCycle
                    
                    var newPeriodLength = (records![0]["endDate"] as! Date).timeIntervalSince(records![0]["startDate"] as! Date)
                    records![0]["periodLength"] = Int(Int(newPeriodLength)/60/60/24)
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
                                    
                                    records![0].saveInBackground { (success, error) in
                                        if success{
                                            print("new averages saved")
                                            self.dismiss(animated: true, completion: nil)
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
                        records![i]["daysBetweenPeriod"] = Int(Int(newCycle)/60/60/24)
                        var newPeriodLength = (records![i]["endDate"] as! Date).timeIntervalSince(records![i]["startDate"] as! Date)
                        records![i]["periodLength"] = Int(Int(newPeriodLength)/60/60/24)
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
                                        
                                        records![0].saveInBackground { (success, error) in
                                            if success{
                                                print("new averages saved")
                                                self.dismiss(animated: true, completion: nil)
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    func getAverageLength() {
        
        let query = PFQuery(className: "Preferences")
        query.includeKey("author")
        query.whereKey("author", equalTo: PFUser.current() as Any)
        query.findObjectsInBackground {
            (records, error)in
            if(records != nil){
                self.averageLength = records?[0]["averageDaysinPeriod"] as! Int
            }
            else{
                print("error loading data")
            }
        }
        
    }
    
    func getAverageDaysinPeriod(){
        let query = PFQuery(className: "Preferences")
        query.includeKey("author")
        query.whereKey("author", equalTo: PFUser.current() as Any)
        query.findObjectsInBackground {
            (records, error)in
            if(records != nil){
                self.averageCycle = records?[0]["averageDaysBtwnPeriod"] as! Int
            }
            else{
                print("error loading data")
            }
        }
    }
    
}
