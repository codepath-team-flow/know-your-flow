//
//  EditDateViewController.swift
//  know-your-flow
//
//  Created by Sophia Sun on 5/3/19.
//  Copyright © 2019 debbienvo. All rights reserved.
//

import UIKit

class EditDateViewController: UIViewController {

    @IBOutlet weak var StartDateLabel: UILabel!
 
    @IBOutlet weak var costomDatePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d,yyyy"
        StartDateLabel.text = dateFormatter.string(from: Date())
        
        //
        costomDatePicker?.datePickerMode = .date
        costomDatePicker?.addTarget(self, action: #selector(EditDateViewController.dateChanged(datePicker:)), for: .valueChanged)
        

        // Do any additional setup after loading the view.
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d,yyyy"
        StartDateLabel.text = dateFormatter.string(from: datePicker.date)
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
