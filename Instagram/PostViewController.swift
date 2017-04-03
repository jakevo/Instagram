//
//  PostViewController.swift
//  Instagram
//
//  Created by Jake Vo on 3/12/17.
//  Copyright © 2017 Jake Vo. All rights reserved.
//

import UIKit
import Parse

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var comment: UITextField!
    @IBOutlet var picUpload: UIImageView!
    @IBOutlet var publishBtn: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        publishBtn.isEnabled = false
        publishBtn.backgroundColor = .lightGray
        picUpload.image = UIImage (named: "placeholder")
        comment.becomeFirstResponder()
        
        let picTap = UITapGestureRecognizer(target: self, action: #selector(PostViewController.chooseImage))
        picTap.numberOfTapsRequired = 1
        picUpload.isUserInteractionEnabled = true
        picUpload.addGestureRecognizer(picTap)

    }
    
    func chooseImage() {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picUpload.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
        // enable publish btn
        publishBtn.isEnabled = true
        publishBtn.backgroundColor = UIColor.red
        
        // implement second tap for zooming image
        let zoomTap = UITapGestureRecognizer(target: self, action: #selector(PostViewController.zoomImg))
        zoomTap.numberOfTapsRequired = 1
        picUpload.isUserInteractionEnabled = true
        picUpload.addGestureRecognizer(zoomTap)
    }
    
    // zooming in / out function
    func zoomImg() {
        
        // define frame of zoomed image
        let zoomed = CGRect(x: 0, y: self.view.center.y - self.view.center.x - self.tabBarController!.tabBar.frame.size.height * 1.5, width: self.view.frame.size.width, height: self.view.frame.size.width)
        
        // frame of unzoomed (small) image
        let unzoomed = CGRect(x: 15, y: 15, width: self.view.frame.size.width / 4.5, height: self.view.frame.size.width / 4.5)
        
        // if picture is unzoomed, zoom it
        if picUpload.frame == unzoomed {
            
            // with animation
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                // resize image frame
                self.picUpload.frame = zoomed
                
                // hide objects from background
                self.view.backgroundColor = .black
                self.comment.alpha = 0
                self.publishBtn.alpha = 0
            })
            
            // to unzoom
        } else {
            
            // with animation
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                // resize image frame
                self.picUpload.frame = unzoomed
                
                // unhide objects from background
                self.view.backgroundColor = .white
                self.comment.alpha = 1
                self.publishBtn.alpha = 1
                //self.removeBtn.alpha = 1
            })
        }
        
    }

    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPublish(_ sender: Any) {
        
        let object = PFObject(className: "posts")
        object["username"] = PFUser.current()!.username
        
        object["ava"] = PFUser.current()!.value(forKey: "ava") as! PFFile
        
        if (comment.text?.isEmpty)! {
            object["title"] = ""
        } else {
            object["title"] = comment.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        let imageData = UIImageJPEGRepresentation(picUpload.image!, 0.5)
        let imageFile = PFFile(name: "post.jpg", data: imageData!)
        object["pic"] = imageFile
        
        object.saveInBackground (block: { (success, error) -> Void in
            if error == nil {
                
                // switch to another ViewController at 0 index of tabbar
                self.tabBarController!.selectedIndex = 0
                
                // reset everything
                self.viewDidLoad()
                self.comment.text = ""
            }
        })


        
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
