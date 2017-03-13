//
//  ViewController.swift
//  Instagram
//
//  Created by Jake Vo on 3/12/17.
//  Copyright © 2017 Jake Vo. All rights reserved.
//

import UIKit
import Parse


class LoginViewController: UIViewController {

    @IBOutlet var emailText: UITextField!
    @IBOutlet var passwordText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.navigationBar.isHidden = true
    }
    
    

    @IBAction func onLogin(_ sender: Any) {
        
        if (emailText.text?.isEmpty)! || (passwordText.text?.isEmpty)! {
            
            alertControl(title: "Error:", message: " Missing Username/Password!")
            
        } else {
         
            PFUser.logInWithUsername(inBackground: emailText.text!, password: passwordText.text!, block: { (user, error) in
                
                if error != nil {
                    
                    var displayErrorMessage = "Please try again later."
                    
                    //let error = error as NSError?
                    
                    if let errorMessage = error?.localizedDescription {
                        displayErrorMessage = errorMessage
                    }
                    
                    self.alertControl(title: "Login Error", message: displayErrorMessage)
                } else {
                    
                    print("Logged in")
                    
            
                    UserDefaults.standard.set(user!.username, forKey: "username")
                    UserDefaults.standard.synchronize()
                    
                    let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.login()
                    //self.performSegue(withIdentifier: "showHomepage", sender: self)
                }
            })
        }
    }
    
    
    
    
    
    func alertControl (title: String, message: String) {
        
        let alertControler = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        //button in alert box
        alertControler.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alertControler, animated: true, completion: nil)
    }

}

