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
    
    let dateFormatter = DateFormatter()
    let componentsFormatter = DateComponentsFormatter()
    
    var endDateString = "Apr 3, 2019";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "MMM d, yyyy"
        StartDateLabel.text = dateFormatter.string(from: costomDatePicker.date)
        endDateString = dateFormatter.string(from: (costomDatePicker.date+5*(60*60*24)))
        //
        costomDatePicker?.datePickerMode = .date
        costomDatePicker?.addTarget(self, action: #selector(EditDateViewController.dateChanged(datePicker:)), for: .valueChanged)
        

        // Do any additional setup after loading the view.
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
       
        dateFormatter.dateFormat = "MMM d, yyyy"
        StartDateLabel.text = dateFormatter.string(from: datePicker.date)
        endDateString = dateFormatter.string(from: datePicker.date+5*(60*60*24))
        //print(datePicker.date)
        //print(datePicker.date+5*(60*60*24))
        //dateString = StartDateLabel.text
    }
    
    
    @IBAction func onSubmitButton(_ sender: Any) {
        let period = PFObject(className: "PeriodHistory")
        period["startDate"] = dateFormatter.date(from : StartDateLabel.text ?? dateFormatter.string(from: costomDatePicker.date))
        period["endDate"] = dateFormatter.date(from : endDateString ?? dateFormatter.string(from: costomDatePicker.date))
        period["author"] = PFUser.current()
        
//        //get difference between start and end date
//        let dateRangeStart = period["startDate"]
//        let dateRangeEnd = period["endDate"]
//        componentsFormatter.allowedUnits = [.day]
//        componentsFormatter.unitsStyle = .full
//        period["periodLength"] = componentsFormatter.string(from: dateRangeStart as! Date, to: dateRangeEnd as! Date)
        
        period.saveInBackground { (success, error) in
            if success{
                print("period saved")
                self.dismiss(animated: true, completion: nil)
            }else{
                print("error saving period")
            }
        }
    }
    
    @IBAction func onDismissButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
