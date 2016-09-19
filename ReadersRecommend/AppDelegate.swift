//
//  AppDelegate.swift
//  ReadersRecommend
//
//  Created by Olivia Murphy on 9/15/16.
//  Copyright © 2016 Murphy. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let stack = CoreDataStack(modelName: "Model")!
    
    var sharedSession = NSURLSession.sharedSession()
    
    func applicationWillResignActive(application: UIApplication) {
        do {
            try stack.saveContext()
        }
        catch {
            print ("Error saving context")
        }
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        do {
            try stack.saveContext()
        }
        catch {
            print ("Error saving context")
        }
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        UINavigationBar.appearance().barTintColor = UIColor(red: 183.0/255.0, green: 206.0/255.0, blue: 99.0/255.0, alpha: 1.0)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UITabBar.appearance().barTintColor = UIColor(red: 183.0/255.0, green: 206.0/255.0, blue: 99.0/255.0, alpha: 1.0)
        UITabBar.appearance().tintColor = UIColor.whiteColor()
        
        stack.autoSave(60)
        
        return true
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

