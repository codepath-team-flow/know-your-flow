//
//  PreferencesViewController.swift
//  know-your-flow
//
//  Created by Debbie Vo on 5/8/19.
//  Copyright © 2019 debbienvo. All rights reserved.
//
//  User Placeholder Image credited to Appalachian College Association
//  https://acaweb.org/profile-placeholder/


import UIKit
import Parse
import AlamofireImage

class PreferencesViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var ageLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var averageDaysinPeriodLabel: UILabel!
    
    @IBOutlet weak var averageDaysBtwnCyclesLabel: UILabel!
    
    let preferences = PFObject(className: "Preferences")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        nameLabel.text = PFUser.current()?["name"] as! String
        ageLabel.text = PFUser.current()?["age"] as! String
        

        

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        renderData()
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    @IBAction func onProfileButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
        
    }
    
    func renderData(){
        let query = PFQuery(className: "Preferences")
        query.includeKey("author")
        query.whereKey("author", equalTo: PFUser.current())
        query.findObjectsInBackground {
            (records, error)in
            if(records != nil){
                if(records![0]["profileImage"] != nil){
                    var imageObj = records![0]["profileImage"] as! PFFileObject
                    let urlString = imageObj.url
                    let url = URL(string: urlString!)
                    self.imageView.af_setImage(withURL: url!)
                    
                }
                self.averageDaysinPeriodLabel.text = String(records![0]["averageDaysinPeriod"] as! Int) + "days"
                self.averageDaysBtwnCyclesLabel.text = String(records![0]["averageDaysBtwnPeriod"] as! Int) + "days"
            }
            else{
                print("error loading data")
            }
            
            


        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af_imageScaled(to: size)
        imageView.image = scaledImage
        
        
        preferences["author"] = PFUser.current()!
        let imageData = imageView.image!.pngData()
        let file = PFFileObject(data: imageData!)
        preferences["profileImage"] = file
        preferences.saveInBackground { (success, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
                print("Saved Image in DB")
            } else {
                print("Error")
            }
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func onLogoutButton(_ sender: Any) {
        PFUser.logOut()
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.window?.rootViewController = loginViewController
    }
}
