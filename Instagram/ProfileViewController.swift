//
//  ProfileViewController.swift
//  Instagram
//
//  Created by Jake Vo on 3/12/17.
//  Copyright © 2017 Jake Vo. All rights reserved.
//

import UIKit
import Parse
class ProfileViewController: UIViewController {

    
    @IBOutlet var profilePic: UIImageView!
    @IBOutlet var firstName: UILabel!
    @IBOutlet var webField: UILabel!
    
    @IBOutlet var userDescription: UILabel!
    @IBOutlet var userPics: UICollectionView!
    
    
    @IBAction func updateProfile(_ sender: Any) {
        
        
        
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        
        let username =  defaults.string(forKey: "username")
        
        
        let infoQuery = PFQuery(className: "_User")
        infoQuery.whereKey("username", equalTo: username!)
        
        infoQuery.findObjectsInBackground (block: { (objects, error) -> Void in
        
            if error != nil {
                
                self.alertControl(title: "Instagram", message: (error?.localizedDescription)!)
            } else {
                
                for object in objects! {
                    
                    self.firstName.text = (object.object(forKey: "fullname") as? String)?.uppercased()
                    
                    self.userDescription.text = (object.object(forKey: "bio") as? String)?.uppercased()
                    let avaFile : PFFile = (object.object(forKey: "ava") as? PFFile)!
                    
                    avaFile.getDataInBackground { (data, error) in
                        
                        if let imageData = data {
                            
                            if let downloadedImage = UIImage(data: imageData) {
                                
                                self.profilePic.image = downloadedImage
                            }
                        }
                    }
                    
                    self.webField.text = (object.object(forKey: "web") as? String)!


                }
                
            }
            
            
        })
        
        
        
        
        // Do any additional setup after loading the view.
    }

    func alertControl (title: String, message: String) {
        
        let alertControler = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        //button in alert box
        alertControler.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alertControler, animated: true, completion: nil)
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
