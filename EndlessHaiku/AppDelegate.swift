//
//  AppDelegate.swift
//  EndlessHaiku
//
//  Created by Thinh Luong on 1/19/16.
//  Copyright © 2016 Thinh Luong. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import MoPub

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  var adView: MPAdView?
  
  //  private func loadAdView() {
  //    let adUnitId: String?
  //    var adSize = CGSize.zero
  //    
  //    switch UIDevice.currentDevice().userInterfaceIdiom {
  //    case .Pad:
  //      adUnitId = MoPubAdUnitId.leaderboard
  //      adSize = MOPUB_LEADERBOARD_SIZE
  //    case .Phone:
  //      adUnitId = MoPubAdUnitId.banner
  //      adSize = MOPUB_BANNER_SIZE
  //    default: return
  //    }
  //    
  //    adView = MPAdView(adUnitId: adUnitId, size: adSize)
  //    
  //    let xPosition = (view.bounds.size.width - adSize.width) / 2
  //    let yPosition = view.bounds.size.height - adSize.height
  //    
  //    
  //    // Positions the ad at the bottom, with the correct size
  //    adView.frame = CGRect(x: xPosition, y: yPosition, width: adSize.width, height: adSize.height)
  //    view.addSubview(adView)
  //    
  //    // Loads the ad over the network
  //    adView.loadAd()
  //    
  //  }
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.
    Fabric.with([Crashlytics.self, MoPub.self])
    
    adView = getAdView()
    
    return true
  }
  
  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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

