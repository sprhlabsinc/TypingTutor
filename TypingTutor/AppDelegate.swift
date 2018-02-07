//
//  AppDelegate.swift
//  TypingTutor
//
//  Created by Sergey Lukjanov on 4/24/17.
//  Copyright © 2017 JinHe Wang. All rights reserved.
//

import UIKit
import SQLite

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        

        do {
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
                ).first!
            
            let db = try Connection("\(path)/db.sqlite3")
            
            let records = Table("records")

            let id = Expression<Int64>("id")
            let name = Expression<String>("name")
            let speed = Expression<Double>("speed")
            let regtime = Expression<String>("regtime")
            
            try db.run(records.create { t in     // CREATE TABLE "users" (
                t.column(id, primaryKey: .autoincrement)
                t.column(name)  //     "email" TEXT UNIQUE NOT NULL,
                t.column(speed, defaultValue: 0)
                t.column(regtime)//     "name" TEXT
            })                                 // )
        }
        catch {
            
        }
        
        let defaults = UserDefaults.standard
        let username = defaults.string(forKey: KUsername)
        
        if (username != nil && username != "") {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)        
            let mainViewController = storyboard.instantiateViewController(withIdentifier: "homeVC") as! UITabBarController
            self.window?.rootViewController = mainViewController
            self.window?.makeKeyAndVisible()
        }
        
        let speed = defaults.integer(forKey: KSpeed)
        let delay = defaults.integer(forKey: KDelay)
        
        if (speed == 0) {
            defaults.setValue(5, forKey: KSpeed)
        }
        if (delay == 0) {
            defaults.setValue(3, forKey: KDelay)
        }
        defaults.synchronize()
        
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


}

