//
//  AppDelegate.swift
//  Colour Trek
//
//  Created by Daniel Meechan on 31/08/2017.
//  Copyright © 2017 Rogue Studios. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.makeKeyAndVisible()
    
    window?.rootViewController = GameViewController()
    
    let appID = "ca-app-pub-4605466962808569~5941669316"
    GADMobileAds.configure(withApplicationID: appID)
    FirebaseApp.configure()
    
    return true
    
  }


}

