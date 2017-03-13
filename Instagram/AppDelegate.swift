//
//  AppDelegate.swift
//  Instagram
//
//  Created by Jake Vo on 3/12/17.
//  Copyright © 2017 Jake Vo. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Parse.enableLocalDatastore()
        
        let parseConfiguration = ParseClientConfiguration(block: { (ParseMutableClientConfiguration) -> Void in
            ParseMutableClientConfiguration.applicationId = "e8a33a2a0b4eea93f3afa71cac92dd1d745e95b8"
            ParseMutableClientConfiguration.clientKey = "db652864d6dfe2082ac145cef66ad8b0270802e5"
            ParseMutableClientConfiguration.server = "http://ec2-54-201-55-50.us-west-2.compute.amazonaws.com:80/parse"
            
        })
        
        Parse.initialize(with: parseConfiguration)
        
        //PFUser.enableAutomaticUser()
        
        let defaultACL = PFACL();
        
        // If you would like all objects to be private by default, remove this line.
        defaultACL.getPublicReadAccess = true
        
        PFACL.setDefault(defaultACL, withAccessForCurrentUser: true)
        
        login()
        
        // color of window
        window?.backgroundColor = .white
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func login() {
        
        
        if PFUser.current() != nil {
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let myTabBar = storyboard.instantiateViewController(withIdentifier: "tabbar") as! UITabBarController
            window?.rootViewController = myTabBar
        }
        
        
    }


}

