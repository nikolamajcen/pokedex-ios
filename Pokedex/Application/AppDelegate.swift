//
//  AppDelegate.swift
//  Pokedex
//
//  Created by Nikola Majcen on 04/04/16.
//  Copyright © 2016 Nikola Majcen. All rights reserved.
//

import UIKit
import ChameleonFramework

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let tabController = window?.rootViewController
        let tabBar = (tabController as! UITabBarController).tabBar
        tabBar.barStyle = UIBarStyle.Black
        tabBar.barTintColor = UIColor.flatWhiteColor()
                
        let navigationControllers = tabController!.childViewControllers
        for navigationController in navigationControllers {
            let navigationBar = (navigationController as! UINavigationController).navigationBar
            navigationBar.barStyle = UIBarStyle.Black
            navigationBar.tintColor = UIColor.flatWhiteColor()
        }
                
        return true
    }
}

