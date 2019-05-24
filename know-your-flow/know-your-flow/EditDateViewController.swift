//
//  EditDateViewController.swift
//  know-your-flow
//
//  Created by Sophia Sun on 5/3/19.
//  Copyright © 2019 debbienvo. All rights reserved.
//

import UIKit
import Parse

class EditDateViewController: UIViewController {
    
    @IBOutlet weak var StartDateLabel: UILabel!
    
    @IBOutlet weak var costomDatePicker: UIDatePicker!
    @IBOutlet weak var endDaysLable: UILabel!
    
    let dateFormatter = DateFormatter()
    let componentsFormatter = DateComponentsFormatter()
    var endDateString = "Apr 3, 2019";
    var periodHistory = [PFObject]()
    var predictedDate = Date()
    var averageLength = 5
    var averageCycle = 28
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAverageLength()
        getAverageDaysinPeriod()
        dateFormatter.dateFormat = "MMM d, yyyy"
        StartDateLabel.text = dateFormatter.string(from: costomDatePicker.date)
        
        costomDatePicker?.datePickerMode = .date
        costomDatePicker?.addTarget(self, action: #selector(EditDateViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        queryHistory()
        
        
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        
        dateFormatter.dateFormat = "MMM d, yyyy"
        StartDateLabel.text = dateFormatter.string(from: datePicker.date)
        endDateString = dateFormatter.string(from: (costomDatePicker.date+TimeInterval(averageLength*(60*60*24)) ))
        endDaysLable.text = "Expected to end in " + String(averageLength) + " days"
        
    }
    
    
    @IBAction func onSubmitButton(_ sender: Any) {
        
        
        
        let period = PFObject(className: "PeriodHistory")
        period["startDate"] = dateFormatter.date(from : StartDateLabel.text ?? dateFormatter.string(from: costomDatePicker.date))
        period["endDate"] = dateFormatter.date(from : endDateString ?? dateFormatter.string(from: costomDatePicker.date))
        period["author"] = PFUser.current()
        
        //period Length
        let length = (period["endDate"] as! Date).timeIntervalSince(period["startDate"] as! Date)
        period["periodLength"] = Int(length)/60/60/24
        
        if(self.periodHistory.count == 0){
            //TODO: first check if user entered their average at sign up. if not set to 28
            period["daysBetweenPeriod"] = self.averageCycle
        }else{
            let lastStartDate = findLastPeriodStartDate(date: period["startDate"] as! Date)
            print("lastStartDate")
            print(lastStartDate)
            
            let difference = (period["startDate"] as! Date).timeIntervalSince(lastStartDate as! Date)
            
            period["daysBetweenPeriod"] = Int(difference)/60/60/24
            
        }
        
        //average days between period
        self.averageCycle = calcAverage(count: self.periodHistory.count, newNumberOfDays: period["daysBetweenPeriod"] as! Int)
        
        
        self.predictedDate = (period["startDate"] as! Date) + TimeInterval(self.averageCycle*60*60*24)
        period["predictedDate"] = predictedDate
        
        //average period length
        self.averageLength = calcAveragePeriodLength(count: self.periodHistory.count, newNumberOfDays: period["periodLength"] as! Int)
        
        // save to Preference table
        let queryPreferences = PFQuery(className:"Preferences")
        queryPreferences.includeKey("author")
        queryPreferences.whereKey("author", equalTo: PFUser.current())
        queryPreferences.findObjectsInBackground {
            (records, error)in
            if(records != nil){
                records![0]["averageDaysBtwnPeriod"] = self.averageCycle
                records![0]["averageDaysinPeriod"] = self.averageLength
                print(self.averageCycle)
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
            
        
        
        //save to PeriodHistory
        period.saveInBackground { (success, error) in
            if success{
                print("period saved")
                self.dismiss(animated: true, completion: nil)
            }else{
                print("error saving period")
            }
        }
        
        
    }
    
    func calcAverage(count: Int, newNumberOfDays: Int) -> Int{
        //TODO: handle new entry is in between data
        //if count < 6, then add differences of what we have, devided by count.
        var total = 0
        if(count < 6){
            for period in self.periodHistory {
                total += (period["daysBetweenPeriod"] as! Int)
            }
            
            return (total+newNumberOfDays) / (count + 1)
        }
        else{
            //else: add the differences of the last 6, devide by 6
            var counter = 6
            while(counter > 0){
                total += self.periodHistory[counter - 1]["daysBetweenPeriod"] as! Int
                counter -= 1
            }
            return (total+newNumberOfDays) / (6 + 1)
            
        }
        
    }
    func calcAveragePeriodLength(count: Int, newNumberOfDays: Int) -> Int{
        //TODO: handle new entry is in between data
        //if count < 6, then add differences of what we have, devided by count.
        var total = 0
        if(count < 6){
            for period in self.periodHistory {
                total += (period["periodLength"] as! Int)
            }
            
            return (total+newNumberOfDays) / (count + 1)
        }
        else{
            //else: add the differences of the last 6, devide by 6
            var counter = 6
            while(counter > 0){
                total += self.periodHistory[counter - 1]["periodLength"] as! Int
                counter -= 1
            }
            return (total+newNumberOfDays) / (6 + 1)
            
        }
        
    }
    
    
    @IBAction func onDismissButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
    
    // for calculating length, find last period start date.
    func findLastPeriodStartDate(date: Date) -> Date {
        let lastStartDate: Date
        let newEntry = date
        var count = periodHistory.count
        var curr = periodHistory[count - 1]["startDate"] as! Date
        print("curr")
        print("newEntry")
        print(newEntry)
        if(count == 1){
            return curr
        }else{
            while(curr >= newEntry ){
                count -= 1
                curr = periodHistory[count-1]["startDate"] as! Date
                
                //TODO:handle exception, overflow
            }
        }
        
        print("last period startdate")
        print(curr)
        return curr
    }
    
    func getAverageLength() {
        
        let query = PFQuery(className: "Preferences")
        query.includeKey("author")
        query.whereKey("author", equalTo: PFUser.current())
        query.findObjectsInBackground {
            (records, error)in
            if(records != nil){
                self.averageLength = records?[0]["averageDaysinPeriod"] as! Int
                self.endDateString = self.dateFormatter.string(from: (self.costomDatePicker.date+TimeInterval(self.averageLength*(60*60*24)) ))
                self.endDaysLable.text = "Expected to end in " + String(self.averageLength) + " days"
                
            }
            else{
                print("error loading data")
            }
        }
        
    }
    
    func getAverageDaysinPeriod(){
        let query = PFQuery(className: "Preferences")
        query.includeKey("author")
        query.whereKey("author", equalTo: PFUser.current())
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
