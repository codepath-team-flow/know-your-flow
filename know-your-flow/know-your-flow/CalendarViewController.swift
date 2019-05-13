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

class CalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
    
//    fileprivate weak var calendar: FSCalendar!
    
    @IBOutlet weak var calendar: FSCalendar!
    
    @IBOutlet weak var dateLabel: UILabel!
    let dateFormatter = DateFormatter()
    var eventDays = [Date]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.dataSource = self
        calendar.delegate = self
        
        calendar.appearance.borderRadius = 0
        calendar.appearance.headerMinimumDissolvedAlpha = 0
        
        
        let query = PFQuery(className: "PeriodHistory")
        query.includeKey("author")
        query.whereKey("author", equalTo: PFUser.current())
        query.order(byDescending: "startDate")
        query.findObjectsInBackground{
            (records, error) in
            if records != nil {
                for record in records! {
                    print(record)
                    self.eventDays.append(record["startDate"] as! Date)
                    self.eventDays.append(record["endDate"] as! Date)
                }
                print(self.eventDays)
                self.calendar.reloadData()
            }
            
        }
      
        
       

//        calendar.target(forAction: #selector(CalendarViewController.didChanged(selectedDate:)), withSender: Any?.self)
   
        
    }
//
//    @objc func didChanged(selectedDate: NSDate){
//
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
//    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
//        if (calendar.today==date) {
//            return "today";
//        }
//        return nil
//    }
//
//
//    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
//        if eventDays.contains(date){
//            return 1
//        }
//        return 0
//    }
//    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
//
//        let cell = calendar.dequeueReusableCell(withIdentifier: "CELL", for: date, at: position)
//        if eventDays.contains(date){
//
//            cell.isSelected = true
//        }
//        return cell
//    }
    
    // FSCalendarDelegate
//    func calendar(calendar: FSCalendar!, didSelectDate date: NSDate!) {
//        dateFormatter.dateFormat = "MMM d, yyyy"
//        dateLabel.text = dateFormatter.string(from: date as Date)
//    }
//
}


