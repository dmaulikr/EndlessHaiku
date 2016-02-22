//
//  Device.swift
//  EndlessHaiku
//
//  Created by Thinh Luong on 1/20/16.
//  Copyright © 2016 Thinh Luong. All rights reserved.
//


import UIKit


let orientation: UIInterfaceOrientation = UIApplication.sharedApplication().statusBarOrientation

/// current device with more accuracy.
var currentDevice: Device {
get {
  let screenSize = UIScreen.mainScreen().bounds.size
  //  print(screenSize)
  
  switch screenSize {
  case ScaleFactor.iPhone4.size:
    return Device.iPhone4
  case ScaleFactor.iPhone5.size:
    return Device.iPhone5
  case ScaleFactor.iPhone6.size:
    return Device.iPhone6
  case ScaleFactor.iPhone6Plus.size:
    return Device.iPhone6Plus
  case ScaleFactor.iPad.size:
    return Device.iPad
  case ScaleFactor.iPadPro.size:
    return Device.iPadPro
  default:
    return Device.iPhone4
  }
}
}

enum Device: Int {
  case iPhone4, iPhone5, iPhone6, iPhone6Plus, iPad, iPadPro
}

/**
 *  Sizes and scale factors of all devices.
 */
struct ScaleFactor {
  
  struct iPhone4 {
    static let widthProtrait: CGFloat = 320
    static let heightProtrait: CGFloat = 480
    
    static var size: CGSize {
      if orientation.isLandscape {
        return CGSize(width: heightProtrait, height: widthProtrait)
      } else {
        return CGSize(width: widthProtrait, height: heightProtrait)
      }
    }
  }
  
  struct iPhone5 {
    static let widthProtrait: CGFloat = 320
    static let heightProtrait: CGFloat = 568
    
    static var size: CGSize {
      if orientation.isLandscape {
        return CGSize(width: heightProtrait, height: widthProtrait)
      } else {
        return CGSize(width: widthProtrait, height: heightProtrait)
      }
    }
    
    static var scale: CGSize {
      if orientation.isLandscape {
        return CGSize(width: heightProtrait / iPhone4.heightProtrait, height: widthProtrait / iPhone4.widthProtrait)
      } else {
        return CGSize(width: widthProtrait / iPhone4.widthProtrait, height: heightProtrait / iPhone4.heightProtrait)
      }
    }
  }
  
  struct iPhone6 {
    static let widthProtrait: CGFloat = 375
    static let heightProtrait: CGFloat = 667
    
    static var size: CGSize {
      if orientation.isLandscape {
        return CGSize(width: heightProtrait, height: widthProtrait)
      } else {
        return CGSize(width: widthProtrait, height: heightProtrait)
      }
    }
    
    static var scale: CGSize {
      if orientation.isLandscape {
        return CGSize(width: heightProtrait / iPhone4.heightProtrait, height: widthProtrait / iPhone4.widthProtrait)
      } else {
        return CGSize(width: widthProtrait / iPhone4.widthProtrait, height: heightProtrait / iPhone4.heightProtrait)
      }
    }
  }
  
  struct iPhone6Plus {
    static let widthProtrait: CGFloat = 414
    static let heightProtrait: CGFloat = 736
    
    static var size: CGSize {
      if orientation.isLandscape {
        return CGSize(width: heightProtrait, height: widthProtrait)
      } else {
        return CGSize(width: widthProtrait, height: heightProtrait)
      }
    }
    
    static var scale: CGSize {
      if orientation.isLandscape {
        return CGSize(width: heightProtrait / iPhone4.heightProtrait, height: widthProtrait / iPhone4.widthProtrait)
      } else {
        return CGSize(width: widthProtrait / iPhone4.widthProtrait, height: heightProtrait / iPhone4.heightProtrait)
      }
    }
  }
  
  struct iPad {
    static let widthProtrait: CGFloat = 768
    static let heightProtrait: CGFloat = 1024
    
    static var size: CGSize {
      if orientation.isLandscape {
        return CGSize(width: heightProtrait, height: widthProtrait)
      } else {
        return CGSize(width: widthProtrait, height: heightProtrait)
      }
    }
    
    static var scale: CGSize {
      if orientation.isLandscape {
        return CGSize(width: heightProtrait / iPhone4.heightProtrait, height: widthProtrait / iPhone4.widthProtrait)
      } else {
        return CGSize(width: widthProtrait / iPhone4.widthProtrait, height: heightProtrait / iPhone4.heightProtrait)
      }
    }
  }
  
  
  struct iPadPro {
    static let widthProtrait: CGFloat = 1024
    static let heightProtrait: CGFloat = 1366
    
    static var size: CGSize {
      if orientation.isLandscape {
        return CGSize(width: heightProtrait, height: widthProtrait)
      } else {
        return CGSize(width: widthProtrait, height: heightProtrait)
      }
    }
    
    static var scale: CGSize {
      if orientation.isLandscape {
        return CGSize(width: heightProtrait / iPad.heightProtrait, height: widthProtrait / iPad.widthProtrait)
      } else {
        return CGSize(width: widthProtrait / iPad.widthProtrait, height: heightProtrait / iPad.heightProtrait)
      }
    }
  }
  
}

