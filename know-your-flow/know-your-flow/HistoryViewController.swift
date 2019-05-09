//
//  HistoryViewController.swift
//  know-your-flow
//
//  Created by Sophia Sun on 5/8/19.
//  Copyright © 2019 debbienvo. All rights reserved.
//

import UIKit
import Parse

class HistoryViewController: UIViewController {

    @IBOutlet weak var LastPeriodLabel: UILabel!
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let query = PFQuery(className: "PeriodHistory")
        query.includeKey("author")
        query.whereKey("author", equalTo: PFUser.current())
        query.order(byDescending: "startDate")
        query.findObjectsInBackground{
            (records, error) in
            if records != nil {
                let firstRecord = records?.first
                self.dateFormatter.dateFormat = "MMM d, yyyy"
                let lastStartDate = self.dateFormatter.string(for: firstRecord?["startDate"])
                let lastEndDate = self.dateFormatter.string(for: firstRecord?["endDate"])
                //print(lastDate)
                self.LastPeriodLabel.text =  "\(lastStartDate ?? "no record found") - \(lastEndDate ?? "no record found")"
            }
        }
        // Do any additional setup after loading the view.
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
