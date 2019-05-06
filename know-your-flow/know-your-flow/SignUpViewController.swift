//
//  SignUpViewController.swift
//  know-your-flow
//
//  Created by Debbie Vo on 5/3/19.
//  Copyright © 2019 debbienvo. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var ageField: UITextField!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var usernameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
   
    @IBAction func onCancelSignUp(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func onSignUp(_ sender: Any) {
        let user = PFUser()
        user.username = usernameField.text
        user.email = emailField.text
        user.password = passwordField.text
        user["age"] = ageField.text
        user["name"] = nameField.text
        
        user.signUpInBackground { (success, error) in
            if success {
               self.performSegue(withIdentifier: "signupSegue", sender: nil)
                print("Sign up success")
            } else {
                print("Error: \(error?.localizedDescription)")
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
