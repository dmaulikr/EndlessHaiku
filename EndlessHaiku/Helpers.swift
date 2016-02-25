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
//let fontName = "Helvetica Neue"

/**
Configure the default appearance for UINavigationBar.
*/
func configNavBarAppearance() {
  //  UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
  
  UINavigationBar.appearance().barTintColor = barTintColor
  UINavigationBar.appearance().tintColor = tintColor
  UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor(contrastingBlackOrWhiteColorOn: barTintColor, isFlat: true)]
}

/**
 Retrieve the AppDelegate.
 
 - returns: appDelegate
 */
func getAppDelegate() -> AppDelegate {
  return UIApplication.sharedApplication().delegate as! AppDelegate
}

/**
 Create a MoPub adView.
 
 - returns: an initialized adView
 */
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

/**
 Create an UIImage with a user defined scaling factor.
 
 - parameter named: name of image file
 - parameter scale: scaling factor
 
 - returns: scaled image
 */
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

/**
 Create an UIImage specifically scaled for iPhone 6.
 
 - parameter named: name of image file
 
 - returns: scaled image
 */
func getScaledImageForiPhone6(named: String) -> UIImage? {
  let factor = ScaleFactor.iPhone6.scale.height
  let scale = CGPoint(x: factor, y: factor)
  
  return getScaledImage(named, scale: scale)
  
}

/**
 Create an UIImage specifically scaled for iPad Pro.
 
 - parameter named: name of image file
 
 - returns: scaled image
 */
func getScaledImageForiPadPro(named: String) -> UIImage? {
  let factor = ScaleFactor.iPadPro.scale.height
  let scale = CGPoint(x: factor, y: factor)
  
  return getScaledImage(named, scale: scale)
  
}
















