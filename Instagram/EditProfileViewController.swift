//
//  EditProfileViewController.swift
//  Instagram
//
//  Created by Jake Vo on 3/28/17.
//  Copyright © 2017 Jake Vo. All rights reserved.
//

import UIKit
import Parse

class EditProfileViewController: UIViewController, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var profilePic: UIImageView?
    @IBOutlet var fullName: UITextField?
    @IBOutlet var username: UITextField?
    @IBOutlet var bio: UITextField!
    var fullname:String?
    var nickname:String?
    var imgProfile:UIImageView!
    var desc:String?
    var emailHolder:String?
    
    
    
    @IBOutlet var email: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bio?.text = desc
        self.fullName?.text = fullname
        self.username?.text = nickname
        self.email?.text = emailHolder
        profilePic?.image = imgProfile.image
        profilePic?.layer.cornerRadius = (profilePic?.frame.size.width)! / 2
        profilePic?.clipsToBounds = true
               // Do any additional setup after loading the view.
    }
    
   

    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSave(_ sender: Any) {
        
        if (fullName?.text?.isEmpty)! || (username?.text?.isEmpty)! {
            alertControl(title: "Instagram", message: "Please fill all fields!")
        } else {
            
            let user = PFUser.current()!
            
            if (bio.text?.isEmpty)! {
                bio.text = ""
            }
            
            
            
            user.username = self.username?.text
            
            UserDefaults.standard.set(user.username, forKey: "username")
            UserDefaults.standard.synchronize()

            
            user["fullname"] = self.fullName?.text
            user["bio"] = self.bio?.text
            let avaData = UIImageJPEGRepresentation((profilePic?.image)!, 0.5)
            let avaFile = PFFile(name: "ava.jpg", data: avaData!)
            user["ava"] = avaFile
            
            
            user.saveInBackground(block: { (success, error) in
                if success {
                    self.dismiss(animated: true, completion: nil)
                    
                    let postQuery = PFQuery(className: "posts")
                    //postQuery.whereKey("uuid", equalTo: postuuid.last!)
                    postQuery.findObjectsInBackground (block: { (objects, error) -> Void in
                        if error == nil {
                            
                            // clean up
                            // find related objects
                            for object in objects! {
                                print("Object is \(object["username"]!)")
                                print("Nickname is \(self.nickname!)")
                                if object["username"]! as? String == self.nickname! {
                                    object["username"] = self.username?.text
                                    object["ava"] = avaFile
                                    object.saveInBackground()
                                }
                            }
                            
                        }
                        
                    })
                    
                }
            })
            let userQuery = PFQuery(className: "_User")
            userQuery.findObjectsInBackground (block: { (objects, error) -> Void in
                if error == nil {
                    // clean up
                    // find related objects
                    for object in objects! {
                        print("Object is \(object["username"]!)")
                        print("Nickname is \(self.nickname!)")
                        if object["username"]! as? String == self.nickname! {
                            object["email"] = self.email?.text
                            object.saveInBackground()
                        }
                    }
                    
                }
                
            })

        }
        
    }
    @IBAction func changeProfileImg(_ sender: Any) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        profilePic?.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
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
