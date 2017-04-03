//
//  ProfileViewController.swift
//  Instagram
//
//  Created by Jake Vo on 3/12/17.
//  Copyright © 2017 Jake Vo. All rights reserved.
//

import UIKit
import Parse
import AFNetworking
import MBProgressHUD


class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    @IBOutlet var profilePic: UIImageView!
    @IBOutlet var firstName: UILabel!
    //@IBOutlet var webField: UILabel!
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var editBtn: UIButton!
    @IBOutlet var userDescription: UILabel!
    @IBOutlet var userPics: UICollectionView!
    let defaults = UserDefaults.standard
    var messages = [String]()
    var imageFiles = [PFFile]()
    var ava:PFFile?
    
    
    func getUserPost() {
        
        
        self.imageFiles.removeAll()
        self.messages.removeAll()
        let user = PFUser.current()!
        ava = user["ava"] as? PFFile
        
        let postQuery = PFQuery(className: "posts")
        postQuery.order(byDescending: "createdAt")
        MBProgressHUD.showAdded(to: self.view, animated: true)
        postQuery.findObjectsInBackground (block: { (objects, error) in
            
            if error != nil {
                self.alertControl(title: "Instagram", message: (error?.localizedDescription)!)
            } else {
                
                for object in objects! {
                    
                    if object["username"]! as? String == user.username {
                        self.imageFiles.append(object.value(forKey: "pic") as! PFFile)
                        self.messages.append(object.value(forKey: "title") as! String)
                    }
                }
                
                self.collectionView.reloadData()
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        })
    }
    
    
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return imageFiles.count
    }
    
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "picCell", for: indexPath) as! PictureCellCollectionViewCell
        
        imageFiles[indexPath.row].getDataInBackground { (data, error) in
            
            if let imageData = data {
                
                if let downloadedImage = UIImage(data: imageData) {
                    
                    cell.picCell.image = downloadedImage
                }
            }
        }
        return cell
    }

    @IBAction func updateProfile(_ sender: Any) {
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "editProfile") as! EditProfileViewController
        vc.fullname = firstName.text
        vc.nickname = defaults.string(forKey: "username")
        vc.imgProfile = profilePic
        vc.desc = userDescription.text
        vc.emailHolder = PFUser.current()?.email
        self.present(vc, animated: true, completion: nil)
        //self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        //getUserPost()
        let username =  defaults.string(forKey: "username")
        //self.title = username
        self.navigationController?.navigationBar.topItem?.title = username
        let infoQuery = PFQuery(className: "_User")
        infoQuery.whereKey("username", equalTo: username!)
        
        infoQuery.findObjectsInBackground (block: { (objects, error) -> Void in
            //print("good")
            if error != nil {
                
                self.alertControl(title: "Instagram", message: (error?.localizedDescription)!)
            } else {
                
                for object in objects! {
                    
                    self.firstName.text = (object.object(forKey: "fullname") as? String)
                    
                    self.userDescription.text = (object.object(forKey: "bio") as? String)
                    let avaFile : PFFile = (object.object(forKey: "ava") as? PFFile)!
                    
                    avaFile.getDataInBackground { (data, error) in
                        
                        if let imageData = data {
                            
                            if let downloadedImage = UIImage(data: imageData) {
                                
                                
                                self.profilePic.image = downloadedImage
                                self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width / 2
                                self.profilePic.clipsToBounds = true
                            }
                        }
                    }
                    
                    //self.webField.text = (object.object(forKey: "web") as? String)!
                    
                    
                }
                
            }
            
            
        })
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.tabBar.isHidden = false
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        getUserPost()
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
