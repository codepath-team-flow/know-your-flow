//
//  ActivityHomeViewController.swift
//  know-your-flow
//
//  Created by Debbie Vo on 5/3/19.
//  Copyright © 2019 debbienvo. All rights reserved.
//

import UIKit
import Parse

class ActivityHomeViewController: UIViewController {

    @IBOutlet weak var LastPeriodLabel: UILabel!
    
    let dateFormatter = DateFormatter()
    override func viewDidLoad() {
        super.viewDidLoad()

 
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
    override func viewDidAppear(_ animated: Bool) {
        let query = PFQuery(className: "PeriodHistory")
        query.includeKey("author")
        query.whereKey("author", equalTo: PFUser.current())
        query.order(byDescending: "startDate")
        query.findObjectsInBackground{
            (records, error) in
            if records != nil {
                let firstRecord = records?.first
                self.dateFormatter.dateFormat = "MMM d, yyyy"
                let lastDate = self.dateFormatter.string(for: firstRecord?["startDate"])
                print(lastDate)
                self.LastPeriodLabel.text = lastDate
            }
        }
        
    }

}
