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

    let dateFormatter = DateFormatter()
    var periodDays = [Date]()
    var fertileDays = [Date]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "MMM d, yyyy"
        selectedDateLabel.text = dateFormatter.string(for: Date())
        
        calendar.dataSource = self
        calendar.delegate = self
        
        calendar.appearance.borderRadius = 0
        calendar.appearance.headerMinimumDissolvedAlpha = 0
        
//        calendar.register(FSCalendarCell.self, forCellReuseIdentifier: "CELL")
        
        // append event date to array
        let query = PFQuery(className: "PeriodHistory")
        query.includeKey("author")
        query.whereKey("author", equalTo: PFUser.current())
        query.order(byDescending: "startDate")
        query.findObjectsInBackground{
            (records, error) in
            if records != nil {
                for record in records! {
                    print(record)
                    var curr = record["startDate"] as! Date
                    while(curr <= record["endDate"] as! Date){
                        self.periodDays.append(curr)
                        curr  = curr + (60*60*24)
                    }
                    var temp = record["startDate"] as! Date
                    var averageCycle = (record["averageCycle"] as! Int)
                    temp = temp + TimeInterval((averageCycle/3)*(60*60*24))
                    for _ in 1...5 {
                        self.fertileDays.append(temp)
                        temp = temp + (60*60*24)
                    }
                    
                    //self.eventDays.append(record["startDate"] as! Date)
                    //self.eventDays.append(record["endDate"] as! Date)
                }
              
                self.calendar.reloadData()
            }
            
        }
    }
    
    
// Change subtitle of cell
//    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
//        if (calendar.today==date) {
//            return "today";
//        }
//        return nil
//    }


//    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
//        if periodDays.contains(date){
//            return 1
//        }
//        return 0
//    }
    
    
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
//
//        if periodDays.contains(date) {
//            return UIColor(displayP3Red: 1.0, green: 0.5864, blue: 0.54129, alpha: 0.6)
//            // red = "1.0" green="0.5864" blue="0.54129"
//
//        }
//        return nil
//    }
    
    
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.dateFormatter.dateFormat = "MMM d, yyyy"
        self.selectedDateLabel.text = self.dateFormatter.string(for: date)
    }
    
    
    
 //Change image of cell
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        if periodDays.contains(date){

            return UIImage(named: "pink-line-32")
        }else if (fertileDays.contains(date)){
            return UIImage(named: "blue-line-32")
        }
        return nil
    }
    
// Register Cell
//    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
//
//        let cell = calendar.dequeueReusableCell(withIdentifier: "CELL", for: date, at: position)
//        cell.imageView.contentMode = .scaleAspectFit
//        return cell
//    }
    
    // FSCalendarDelegate
//    func calendar(calendar: FSCalendar!, didSelectDate date: NSDate!) {
//        dateFormatter.dateFormat = "MMM d, yyyy"
//        dateLabel.text = dateFormatter.string(from: date as Date)
//    }
//
}


