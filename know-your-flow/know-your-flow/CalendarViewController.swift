//
//  CalendarViewController.swift
//  know-your-flow
//
//  Created by Sophia Sun on 5/7/19.
//  Copyright © 2019 debbienvo. All rights reserved.
//

import UIKit
import FSCalendar
import Parse

class CalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource,FSCalendarDelegateAppearance {
    
    //    fileprivate weak var calendar: FSCalendar!
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var selectedDateLabel: UILabel!
    @IBOutlet weak var eventDiscriptionLabel: UILabel!
    

    let dateFormatter = DateFormatter()
    var periodDays = [Date]()
    var fertileDays = [Date]()
    let flowPickerData = [String](arrayLiteral: "Spotty", "Very Light", "Light", "Medium", "Heavy", "Very Heavy")
    var averageCycle = 28
    var expectedDays = [Date]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAverageCycle()
   
        dateFormatter.dateFormat = "MMM d, yyyy"
        selectedDateLabel.text = dateFormatter.string(for: Date())
        
        calendar.dataSource = self
        calendar.delegate = self
        
        calendar.appearance.borderRadius = 0
        calendar.appearance.headerMinimumDissolvedAlpha = 0
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        // append event date to array
        super.viewWillAppear(animated)
        let query = PFQuery(className: "PeriodHistory")
        query.includeKey("author")
        query.whereKey("author", equalTo: PFUser.current())
        query.order(byDescending: "startDate")
        query.findObjectsInBackground{
            (records, error) in
            if records != nil {
                self.expectedDays.append(records![0]["predictedDate"] as! Date)
               
                for record in records! {
          
                    
                    var curr = record["startDate"] as! Date
                    while(curr <= record["endDate"] as! Date){
                        self.periodDays.append(curr)
                        curr  = curr + (60*60*24)
                    }
                    var temp = record["startDate"] as! Date
                    
                    temp = temp + TimeInterval((self.averageCycle/3)*(60*60*24))
                    for _ in 1...5 {
                        self.fertileDays.append(temp)
                        temp = temp + (60*60*24)
                    }
                    
                }
                
                
                print("reloading")
                
            }
            self.calendar.reloadData()
            
        }
    }
    
    func getAverageCycle(){
        
        let preferenceQuery = PFQuery(className: "Preferences")
        preferenceQuery.includeKey("author")
        preferenceQuery.whereKey("author", equalTo: PFUser.current() as Any)
        preferenceQuery.findObjectsInBackground{
            (records, error) in
            if(error != nil) {
                print("error quering preferences")
            }else{
                self.averageCycle = records![0]["averageDaysBtwnPeriod"] as! Int
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
   
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.dateFormatter.dateFormat = "MMM d, yyyy"
        self.selectedDateLabel.text = self.dateFormatter.string(for: date)
        
        if periodDays.contains(date){
            self.eventDiscriptionLabel.text = "Period Day"
            
        }else if fertileDays.contains(date){
            self.eventDiscriptionLabel.text = "Fertility Day"
        }else if expectedDays.contains(date){
            self.eventDiscriptionLabel.text = "Expected Period"
        }else{
            self.eventDiscriptionLabel.text = ""
        }
    }
    

    //Change image of cell
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        print(self.expectedDays)
        if periodDays.contains(date){
            return UIImage(named: "pink-line-32")
        }else if (fertileDays.contains(date)){
            return UIImage(named: "blue-line-32")
        }else if (expectedDays.contains(date)){
            return UIImage(named: "green-line-32")
        }
        
        return nil
    }
    
  

}


