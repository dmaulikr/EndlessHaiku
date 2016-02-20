//
//  Helpers.swift
//  EndlessHaiku
//
//  Created by Thinh Luong on 2/8/16.
//  Copyright © 2016 Thinh Luong. All rights reserved.
//

import UIKit
import MoPub
import ChameleonFramework

let barTintColor = FlatLimeDark()
let tintColor = FlatWhite()
let fontName = "Helvetica Neue"

func configNavBarAppearance() {
  UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
  
  UINavigationBar.appearance().barTintColor = barTintColor
  UINavigationBar.appearance().tintColor = tintColor
  UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor(contrastingBlackOrWhiteColorOn: barTintColor, isFlat: true)]
}

func getAppDelegate() -> AppDelegate {
  return UIApplication.sharedApplication().delegate as! AppDelegate
}

func getAdView() -> MPAdView? {
  let adUnitId: String?
  var adSize = CGSize.zero
  
  switch UIDevice.currentDevice().userInterfaceIdiom {
  case .Pad:
    adUnitId = MoPubAdUnitId.leaderboard
    adSize = MOPUB_LEADERBOARD_SIZE
  case .Phone:
    adUnitId = MoPubAdUnitId.banner
    adSize = MOPUB_BANNER_SIZE
  default: return nil
  }
  
  let adView = MPAdView(adUnitId: adUnitId, size: adSize)
  adView.frame = CGRect(x: 0, y: 0, width: adSize.width, height: adSize.height)
  
  return adView
}

func getScaledImage(named: String, scale: CGPoint) -> UIImage? {
  if let image = UIImage(named: named) {
    let size = CGSizeApplyAffineTransform(image.size, CGAffineTransformMakeScale(scale.x, scale.y))
    let hasAlpha = true
    let scale: CGFloat = 0 // Automatically use scale factor of main screen
    UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
    image.drawInRect(CGRect(origin: CGPointZero, size: size))
    
    let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return scaledImage
  } else {
    return nil
  }
}

func getScaledImageForiPhone6(named: String) -> UIImage? {
  if let image = UIImage(named: named) {
    let scaleFactor = ScaleFactor.iPhone6.scale.height
    let size = CGSizeApplyAffineTransform(image.size, CGAffineTransformMakeScale(scaleFactor, scaleFactor))
    let hasAlpha = true
    let scale: CGFloat = 0 // Automatically use scale factor of main screen
    UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
    image.drawInRect(CGRect(origin: CGPointZero, size: size))
    
    let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return scaledImage
  } else {
    return nil
  }
}