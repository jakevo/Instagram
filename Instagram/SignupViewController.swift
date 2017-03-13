//
//  SignupViewController.swift
//  Instagram
//
//  Created by Jake Vo on 3/12/17.
//  Copyright © 2017 Jake Vo. All rights reserved.
//

import UIKit
import Parse

class SignupViewController: UIViewController {

    
    @IBOutlet var usernameField: UITextField!
    
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var repeatPass: UITextField!
    @IBOutlet var fullnameField: UITextField!
    @IBOutlet var bioField: UITextField!
    @IBOutlet var webField: UITextField!
    
    @IBAction func onSignup(_ sender: Any) {
        
        if (emailField.text?.isEmpty)! || (usernameField.text?.isEmpty)! || (passwordField.text?.isEmpty)! || (repeatPass.text?.isEmpty)! || (bioField.text?.isEmpty)! || (fullnameField.text?.isEmpty)! || (webField.text?.isEmpty)!{
            
            self.alertControl(title: "Instagram", message: "Please fill all fields!")
        } else {
            
            if passwordField.text != repeatPass.text {
                
                self.alertControl(title: "Instagram", message: "Passwords  do not match!")
            } else {
                
                let newUser = PFUser()
                
                newUser.email = emailField.text
                newUser.password = passwordField.text
                newUser.username = usernameField.text
                newUser["fullname"] = fullnameField.text?.lowercased()
                newUser["bio"] = bioField.text?.lowercased()
                newUser["web"] = webField.text?.lowercased()
                
                
                
                newUser.signUpInBackground(block: { (success, error) in
                    
                    //self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if error != nil {
                        
                        var displayErrorMessage = "Please try again later."
                        
                        let error = error as NSError?
                        
                        if let errorMessage = error?.localizedDescription {
                            displayErrorMessage = errorMessage
                        }
                        
                        self.alertControl(title: "Signup Error", message: displayErrorMessage)
                        
                    } else {
                        
                        print("user signed up")
                        
                        
                        UserDefaults.standard.set(newUser.username, forKey: "username")
                        UserDefaults.standard.synchronize()
                        //self.performSegue(withIdentifier: "showHomepage", sender: self)
                        let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.login()
                    }
                    
                })
            }
            
            
            
        }
        
        
        
    }
    
    func alertControl (title: String, message: String) {
        
        let alertControler = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        //button in alert box
        alertControler.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alertControler, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    
    //onCancel
    @IBAction func signup(_ sender: Any) {
        let signin = self.storyboard?.instantiateViewController(withIdentifier: "signInVC") as! LoginViewController
        let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = signin
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
