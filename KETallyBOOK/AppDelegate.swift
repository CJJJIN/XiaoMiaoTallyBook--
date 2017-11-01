//
//  AppDelegate.swift
//  KETallyBOOK
//
//  Created by 科文 on 18/09/2017.
//  Copyright © 2017 科文. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        LZImportFiles().verifyPassword()
        setRootContoller()
        setCategoryDB()
        let keyboardManager = IQKeyboardManager.sharedManager()
        keyboardManager.enable = true
        keyboardManager.enableAutoToolbar = false
        keyboardManager.keyboardDistanceFromTextField = 0
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
         LZImportFiles().verifyPassword()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    private func setRootContoller(){
        window = UIWindow.init(frame: kScreenBounds);
        window?.backgroundColor = .white;
        let tabBarControllerConfig = KECustomTabBarControllerConfig.init()
        window?.rootViewController = tabBarControllerConfig.tabBarController
        window?.makeKeyAndVisible()
    }
    
    private func setCategoryDB(){
        let userDefaults = UserDefaults.standard
        let isFirstStart = userDefaults.object(forKey: "isFirstStart") as? Bool
        if isFirstStart == nil{
            userDefaults.set(true, forKey: "isFirstStart")
            userDefaults.synchronize()
            if let path = Bundle.main.path(forResource: "Category", ofType: "plist"){
                let categoryArry = NSArray(contentsOfFile: path) as! Array<Any>
                for dic in categoryArry {
                    var billType = KEBillTypeModel()
                    billType = KEBillTypeModel.bg_object(withKeyValues: (dic as! NSDictionary)) as! KEBillTypeModel
                    billType.bg_save()
                }
                KEHomeBillModel().bg_save()
            }
        }
    }
}

