//
//  HomeViewController.swift
//  Instagram
//
//  Created by Jake Vo on 3/12/17.
//  Copyright © 2017 Jake Vo. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var users = [String: String]()
    var messages = [String]()
    var usernames = [String]()
    var imageFiles = [PFFile]()
    var check = 0
    var avaArray = [PFFile]()
    
   
    
    
    @IBOutlet var tableview: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        // Do any additional setup after loading the view.
        tableview.delegate = self
        tableview.dataSource = self
        
        
        //let query = PFUser.query()
        
        //query?.findObjectsInBackground(block: { (objects, error) in
            
        //print (check)
        getData()
            
            
        
    }
    @IBAction func onLogout(_ sender: Any) {
        
        //performSegue(withIdentifier: "logoutSegue", sender: self)
        PFUser.logOutInBackground { (error) -> Void in
            if error == nil {
                let signin = self.storyboard?.instantiateViewController(withIdentifier: "signInVC") as! LoginViewController
                let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = signin
            }
        }

    }
    
    func getData() {
        
        let userQuery = PFUser.query()
        userQuery?.order(byDescending: "createdAt")
        
         userQuery?.findObjectsInBackground(block: { (objects, error) in
            
            if let users = objects {
                
                self.users.removeAll()
                
                for object in users {
                    
                    if let user = object as? PFUser {
                        
                        self.users[user.objectId!] = user.username!
                    }
                }
            }
            
            let postQuery = PFQuery(className: "posts")
            //postQuery.whereKey("uuid", equalTo: postuuid.last!)
            postQuery.findObjectsInBackground (block: { (objects, error) -> Void in
                if error == nil {
                    
                    // clean up
                    self.avaArray.removeAll(keepingCapacity: false)
                    self.usernames.removeAll(keepingCapacity: false)
                    //self.dateArray.removeAll(keepingCapacity: false)
                    self.imageFiles.removeAll(keepingCapacity: false)
                    self.messages.removeAll(keepingCapacity: false)
                    
                    // find related objects
                    for object in objects! {
                        self.avaArray.append(object.value(forKey: "ava") as! PFFile)
                        self.usernames.append(object.value(forKey: "username") as! String)
                        //self.dateArray.append(object.createdAt)
                        self.imageFiles.append(object.value(forKey: "pic") as! PFFile)
                        //self.uuidArray.append(object.value(forKey: "uuid") as! String)
                        self.messages.append(object.value(forKey: "title") as! String)
                    }
                    
                    self.tableview.reloadData()
                }
            })
            
            
        })
        
    }
    
    
    
    //@available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    //@available(iOS 2.0, *)
    
    override func viewDidAppear(_ animated: Bool) {
        getData()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableview.deselectRow(at: indexPath, animated: true)
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let temp = messages.count - (indexPath.row + 1)
        
            
            let cell = tableview.dequeueReusableCell(withIdentifier: "cell") as! PostCell
            
            imageFiles[temp].getDataInBackground { (data, error) in
                
                if let imageData = data {
                    
                    if let downloadedImage = UIImage(data: imageData) {
                        
                        cell.postImage.image = downloadedImage
                    }
                    
                }
            }
            
            avaArray[temp].getDataInBackground { (data, error) in
                
                if let imageData = data {
                    
                    if let downloadedImage = UIImage(data: imageData) {
                        
                        cell.profilePic.image = downloadedImage
                    }
                }
            }
            
            cell.name.text = usernames[temp]
            cell.message.text = messages[temp]
            
        
        
        
        
        
        return cell
        
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
