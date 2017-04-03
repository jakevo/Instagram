//
//  HomeViewController.swift
//  Instagram
//
//  Created by Jake Vo on 3/12/17.
//  Copyright © 2017 Jake Vo. All rights reserved.
//

import UIKit
import Parse
import Foundation

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var users = [String: String]()
    var messages = [String]()
    var usernames = [String]()
    var imageFiles = [PFFile]()
    var check = 0
    var avaArray = [PFFile]()
    var timeStampArray = [String]()
    let date = Date()
    var currentDate: String?
    var currentMonthAndDay: String?
    var resultHour: String?
    var resultMin: String?

    
    @IBOutlet var tableview: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        // Do any additional setup after loading the view.
        tableview.delegate = self
        tableview.dataSource = self
        prepareDateAndHour()
        
        //let query = PFUser.query()
        
        //query?.findObjectsInBackground(block: { (objects, error) in
            
        //print (check)
        getData()
            
            
        
    }
    
    func convertToLocalTime (utcTime:Date) -> (String) {
        
        var ret = ""
        print ("UTC time is \(utcTime)")
        let stringTemp = String(describing: utcTime)
        let nsStringTime = NSString(string: stringTemp)
        let dateAndHour = nsStringTime.components(separatedBy: " ")
        
        
        //print (dateAndHour[1].components(separatedBy: ":"))
        
        let postHour = dateAndHour[1].components(separatedBy: ":")[0]
        let postMin = dateAndHour[1].components(separatedBy: ":")[1]
        
        let hourDiff = Int(resultHour!)! - abs(Int(postHour)! - 7)
        //posts fall on the current day
        if dateAndHour[0] == currentDate && hourDiff >= 0 {
            
            //post fall on current hour we should display minute
            if abs(Int(postHour)! - 7) == (Int(resultHour!)!) {
                
                ret =  "\(Int(resultMin!)! - Int(postMin)!)m ago"
                
            } else {
                
                //fall on different hour we substract the current hour by the posted hour to get hour
                ret =  "\((Int(resultHour!)!) - abs(Int(postHour)! - 7))h ago"
                
            }
        } else {
            
            //fall on different day
            ret =  getMonth(diff: Int(postHour)! - 7, month: dateAndHour[0].components(separatedBy: "-")[1], date:dateAndHour[0].components(separatedBy: "-")[2])
        }
        print ("ret is \(ret)")
        return ret
    }
    
    func getMonth(diff: Int, month:String, date:String) -> (String) {
        
        var ret = ""
        var monthLetter = ""
        
        switch month {
        case "01":
            monthLetter = "Jan"
        case "02":
            monthLetter = "Feb"
        case "03":
            monthLetter = "Mar"
        case "04":
            monthLetter = "April"
        case "05":
            monthLetter = "May"
        case "06":
            monthLetter = "Jun"
        case "07":
            monthLetter = "Jul"
        case "08":
            monthLetter = "Aug"
        case "09":
            monthLetter = "Sept"
        case "10":
            monthLetter = "Oct"
        case "01":
            monthLetter = "Nov"
        default:
            monthLetter = "Dec"
        }
        
        //diferent day between different zone time, moving back one day
        if diff < 0 {
            
            var dateInt = Int(date)!
            
            dateInt = dateInt - 1
            
            ret =  "\(monthLetter) \(String(describing: dateInt))"
            
        } else {
            
            ret = "\(monthLetter) \(date)"
            
        }
        
        
        return ret
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
        //userQuery?.order(byDescending: "createdAt")
        
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
            postQuery.order(byDescending: "createdAt")
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
                        //let timeString = String (describing: object.value(forKey: "createdAt")!)
                        self.timeStampArray.append(self.convertToLocalTime(utcTime: object.value(forKey: "createdAt")! as! Date))
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
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell") as! PostCell
        
        imageFiles[indexPath.row].getDataInBackground { (data, error) in
            
            if let imageData = data {
                
                if let downloadedImage = UIImage(data: imageData) {
                    
                    cell.postImage.image = downloadedImage
                }
                
            }
        }
        
        avaArray[indexPath.row].getDataInBackground { (data, error) in
            
            if let imageData = data {
                
                if let downloadedImage = UIImage(data: imageData) {
                    
                    cell.profilePic.image = downloadedImage
                    cell.profilePic.layer.cornerRadius = cell.profilePic.frame.size.width/5
                    cell.profilePic.clipsToBounds = true
                }
            }
        }
        
        cell.name.text = usernames[indexPath.row]
        cell.message.text = messages[indexPath.row]
        
        cell.timeStamp.text = timeStampArray[indexPath.row]
        
        
        return cell
        
    }
    
    func prepareDateAndHour() {
        
        let formatterDateType1 = DateFormatter()
        formatterDateType1.dateFormat = "yyyy-MM-dd"
        
        let formatterDateType2 = DateFormatter()
        formatterDateType2.dateFormat = "MMM dd"
        
        let formatterHour = DateFormatter()
        formatterHour.dateFormat = "HH"
        
        let formatterMin = DateFormatter()
        formatterMin.dateFormat = "mm"
        
        currentDate = formatterDateType1.string(from: date)
        currentMonthAndDay = formatterDateType2.string(from: date)
        
        resultHour = formatterHour.string(from: date)
        resultMin = formatterMin.string(from: date)
        
        //print("current hour is \(resultHour!)")
        //print("current date is \(currentDate!) and current Month and Day is \(currentMonthAndDay!) ")
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
