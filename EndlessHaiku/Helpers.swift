//
//  Helpers.swift
//  EndlessHaiku
//
//  Created by Thinh Luong on 2/8/16.
//  Copyright © 2016 Thinh Luong. All rights reserved.
//

import UIKit

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