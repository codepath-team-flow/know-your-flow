//
//  MainTabBarController.swift
//  know-your-flow
//
//  Created by Debbie Vo on 5/16/19.
//  Copyright © 2019 debbienvo. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //index 1 makes the first screen the activity screen
        self.selectedIndex = 1
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
