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
    
    var period : PFObject!
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        print(objectId)
        query.getObjectInBackground(withId: objectId as! String) { (period: PFObject?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else if let record = period {
                self.dateFormatter.dateFormat = "MMM d, yyyy"
                record["startDate"] = self.dateFormatter.date(from : self.startDateTextField.text!)
                record["endDate"] = self.dateFormatter.date(from : self.endDateTextField.text!)
                record["periodLength"] = (record["endDate"] as! Date).timeIntervalSince(record["startDate"] as! Date)/60/60/24

                let lastStartDate = self.findLastStartDate(date: record["startDate"] as! Date)
                record["daysBetweenPeriod"] = (record["startDate"] as! Date).timeIntervalSince(lastStartDate as! Date)/60/60/24
                period!.saveInBackground { (success, error) in
                    if success{
                        print("period edited and saved")
                        self.dismiss(animated: true, completion: nil)
                    }else{
                        print("error editing period")
                    }
                }
            }
        }
        recalculateData()
    }
    
    
    
    
    @IBAction func onBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func recalculateData() {
        
    }
    
    func findLastStartDate(date: Date) -> Date {
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

}
