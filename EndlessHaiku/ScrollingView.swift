//
//  ScrollingView.swift
//  EndlessHaiku
//
//  Created by Thinh Luong on 1/20/16.
//  Copyright © 2016 Thinh Luong. All rights reserved.
//

import UIKit

/// UIView with a scrolling background
class ScrollingView: UIView {
  
  // MARK: Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    loadBackground()
    loadLabels()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Properties
  var haiku: Haiku!
  var haikuLabel = UILabel()
  var authorLabel = UILabel()
  
  var translation: CGFloat = 0
  var scrollDirection = Direction.Right
  let scrollSpeed: CGFloat = 0.1
  
  /**
   Enum for background scrolling direction.
   
   - Left:  scroll left
   - Right: scroll right
   - Up:    scroll up
   - Down:  scroll down
   */
  enum Direction: CGFloat {
    case Left = -1, Right = 1, Up, Down
  }
  
  var mountFuji = UIImage(named: "OfflineMotivation_MountFuji")
  var farm = UIImage(named: "OfflineMotivation_Farm")
  var egypt = UIImage(named: "OfflineMotivation_Egypt")
  var america = UIImage(named: "OfflineMotivation_America")
  var india = UIImage(named: "OfflineMotivation_India")
  
  var backgroundImageIndex: Int = 0
  var backgroundImage: UIImage? {
    get {
      var randomIndex: Int
      repeat {
        randomIndex = Int(arc4random_uniform(5))
      } while randomIndex == backgroundImageIndex
      
      backgroundImageIndex = randomIndex
      
      let image: UIImage?
      
      switch backgroundImageIndex {
      case 0:
        image = mountFuji
      case 1:
        image = farm
      case 2:
        image = egypt
      case 3:
        image = america
      case 4:
        image = india
      default:
        image = mountFuji
      }
      return image
    }
  }
  
  lazy var scrollLayer: CAScrollLayer = {
    [unowned self] in
    
    let scrollLayer = CAScrollLayer()
    scrollLayer.bounds = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
    scrollLayer.position = CGPoint(x: self.bounds.size.width * 0.5, y: self.bounds.size.height * 0.5)
    scrollLayer.borderColor = UIColor.blackColor().CGColor
    scrollLayer.borderWidth = 0
    scrollLayer.scrollMode = kCAScrollHorizontally
    scrollLayer.backgroundColor = UIColor.blackColor().CGColor
    
    return scrollLayer
    }()
  
  lazy var displayLink: CADisplayLink = {
    [unowned self] in
    
    let displayLink = CADisplayLink(target: self, selector: "scrollLayerScroll")
    displayLink.frameInterval = 1
    
    return displayLink
    }()
  
  /// Set the font size according to the fontScale and character count of the second haiku line.
  var haikuTextFont: CGFloat {
    get {
      
      var baseSize: CGFloat
      switch haiku.lines[1].characters.count {
      case 0...30:
        baseSize = 30
      case 31...35:
        baseSize = 24
      case 36...200:
        baseSize = 22
      default:
        baseSize = 30
      }
      
      return baseSize * fontScale
      
    }
  }
  
  /// Scale the font size according to the current device.
  var fontScale: CGFloat {
    get {
      switch currentDevice {
      case .iPhone4:
        return 1
      case .iPhone5:
        return 1.1
      case .iPhone6:
        return 1.3
      case .iPhone6Plus:
        return 1.4
      case .iPad:
        return 1.9
      case .iPadPro:
        return 2.5
      }
    }
  }
}

// MARK: Loading
extension ScrollingView {
  
  /**
   Load the default background to the view
   */
  private func loadBackground() {
    
    switch currentDevice {
    case .iPhone6:
      mountFuji = getScaledImageForiPhone6("OfflineMotivation_MountFuji")
      farm = getScaledImageForiPhone6("OfflineMotivation_Farm")
      egypt = getScaledImageForiPhone6("OfflineMotivation_Egypt")
      america = getScaledImageForiPhone6("OfflineMotivation_America")
      india = getScaledImageForiPhone6("OfflineMotivation_India")
    case .iPadPro:
      mountFuji = getScaledImageForiPadPro("OfflineMotivation_MountFuji")
      farm = getScaledImageForiPadPro("OfflineMotivation_Farm")
      egypt = getScaledImageForiPadPro("OfflineMotivation_Egypt")
      america = getScaledImageForiPadPro("OfflineMotivation_America")
      india = getScaledImageForiPadPro("OfflineMotivation_India")
    default: break
    }
    
    if let image = mountFuji {
      let layer = CALayer()
      layer.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
      layer.contents = image.CGImage
      
      self.layer.addSublayer(scrollLayer)
      scrollLayer.addSublayer(layer)
      
      displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
    }
  }
  
  /**
   Load the labels to the view
   */
  private func loadLabels() {
    
    haikuLabel = UILabel(frame: CGRect(x: bounds.size.width * 0.02, y: bounds.size.height * 0.05, width: bounds.size.width * 0.96, height: bounds.size.height * 0.75))
    haikuLabel.lineBreakMode = .ByWordWrapping
    haikuLabel.numberOfLines = 0
    haikuLabel.textAlignment = NSTextAlignment.Center
    haikuLabel.font = UIFont(name: Font.Verdana, size: 24 * fontScale)
    haikuLabel.backgroundColor = UIColor.clearColor()
    haikuLabel.textColor = UIColor.whiteColor()
    haikuLabel.shadowColor = UIColor.darkGrayColor()
    haikuLabel.shadowOffset = CGSize(width: 1, height: 1)
    
    haikuLabel.adjustsFontSizeToFitWidth = true
    haikuLabel.minimumScaleFactor = 0.2
    
    addSubview(haikuLabel)
    
    authorLabel = UILabel(frame: CGRect(x: bounds.size.width * 0.5, y: bounds.size.height * 0.7, width: bounds.size.width * 0.5, height: bounds.size.height * 0.1))
    authorLabel.lineBreakMode = .ByWordWrapping
    authorLabel.numberOfLines = 0
    authorLabel.textAlignment = NSTextAlignment.Center
    authorLabel.font = UIFont(name: Font.Verdana, size: 14 * fontScale)
    authorLabel.backgroundColor = UIColor.clearColor()
    authorLabel.textColor = UIColor.whiteColor()
    
    authorLabel.adjustsFontSizeToFitWidth = true
    authorLabel.minimumScaleFactor = 0.2
    
    addSubview(authorLabel)
    
    haikuLabel.text = "Swipe"
    authorLabel.text = ""
  }
  
}

// MARK: Scrolling
extension ScrollingView {
  
  /**
   Target action for scrolling the scrollLayer
   */
  func scrollLayerScroll() {
    
    if displayLink.paused == false {
      translation += scrollSpeed * scrollDirection.rawValue
      
      let newPoint = CGPoint(x: translation, y: 0)
      scrollLayer.scrollToPoint(newPoint)
    }
    
    if translation >= mountFuji!.size.width - bounds.size.width || translation <= 0 {
      
      switch scrollDirection {
      case .Left:
        scrollDirection = .Right
      case .Right:
        scrollDirection = .Left
      default:
        break
      }
      
      pauseDisplayLink()
      
      CATransaction.begin()
      let fadeOutAnimation = CABasicAnimation(keyPath: "opacity")
      fadeOutAnimation.fromValue = 1
      fadeOutAnimation.toValue = 0
      fadeOutAnimation.additive = false
      fadeOutAnimation.removedOnCompletion = false
      fadeOutAnimation.fillMode = kCAFillModeForwards
      fadeOutAnimation.beginTime = 0
      fadeOutAnimation.duration = 1.5
      
      CATransaction.setCompletionBlock {
        
        self.scrollLayer.sublayers = nil
        
        if let image = self.backgroundImage {
          let layer = CALayer()
          layer.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
          
          layer.contents = image.CGImage
          self.scrollLayer.addSublayer(layer)
        }
        
        let fadeInAnimation = CABasicAnimation(keyPath: "opacity")
        fadeInAnimation.fromValue = 0
        fadeInAnimation.toValue = 1
        fadeInAnimation.additive = false
        fadeInAnimation.removedOnCompletion = false
        fadeInAnimation.fillMode = kCAFillModeForwards
        fadeInAnimation.beginTime = CACurrentMediaTime() + 1.8
        fadeInAnimation.duration = 1.5
        
        self.scrollLayer.addAnimation(fadeInAnimation, forKey: nil)
        
        let seconds: Double = 3
        let delay = seconds * Double(NSEC_PER_SEC)
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
          self.resumeDisplayLink()
        })
        
      }
      
      scrollLayer.addAnimation(fadeOutAnimation, forKey: nil)
      
      CATransaction.commit()
    }
  }
  
  /**
   Pause the scrolling background
   */
  func pauseDisplayLink() {
    displayLink.paused = true
  }
  
  /**
   Resume scrolling the background
   */
  func resumeDisplayLink() {
    displayLink.paused = false
  }
}


// MARK: Animation
extension ScrollingView {
  
  /**
   Slide the labels in and out of the view according to the direction of the user's swipe.
   
   - parameter direction:  direction of the user's swipe
   - parameter completion: completion handler
   */
  func swipe(direction: Direction, completion: (Bool)->Void) {
    
    let slideOutPosition: CGPoint
    let slideInPosition: CGPoint
    let transitionPosition: CGPoint
    
    switch direction {
    case .Left:
      slideOutPosition = CGPoint(x: -bounds.size.width, y: haikuLabel.frame.origin.y)
      slideInPosition = CGPoint(x: bounds.size.width * 0.02, y: haikuLabel.frame.origin.y)
      transitionPosition = CGPoint(x: bounds.size.width, y: haikuLabel.frame.origin.y)
    case .Right:
      slideOutPosition = CGPoint(x: bounds.size.width, y: haikuLabel.frame.origin.y)
      slideInPosition = CGPoint(x: bounds.size.width * 0.02, y: haikuLabel.frame.origin.y)
      transitionPosition = CGPoint(x: -bounds.size.width, y: haikuLabel.frame.origin.y)
    case .Up:
      slideOutPosition = CGPoint(x: haikuLabel.frame.origin.x, y: -bounds.size.height)
      slideInPosition = CGPoint(x: haikuLabel.frame.origin.x, y: bounds.size.height * 0.05)
      transitionPosition = CGPoint(x: haikuLabel.frame.origin.x, y: bounds.size.height)
    case .Down:
      slideOutPosition = CGPoint(x: haikuLabel.frame.origin.x, y: bounds.size.height)
      slideInPosition = CGPoint(x: haikuLabel.frame.origin.x, y: bounds.size.height * 0.05)
      transitionPosition = CGPoint(x: haikuLabel.frame.origin.x, y: -bounds.size.height)
    }
    
    let duration: NSTimeInterval = 0.8
    let options = UIViewAnimationOptions.CurveEaseInOut
    let delay: NSTimeInterval = 0
    
    UIView.animateWithDuration(duration, delay: delay, options: options, animations: {
      self.haikuLabel.frame.origin = slideOutPosition
      self.haikuLabel.alpha = 0
      
      self.authorLabel.alpha = 0
      
      }, completion: {
        _ in
        
        self.haikuLabel.text = self.haiku.getHaikuLines()
        self.haikuLabel.frame.origin = transitionPosition
        self.haikuLabel.font = UIFont(name: Font.Verdana, size: self.haikuTextFont)
        
        self.authorLabel.text = self.haiku.author
        
        UIView.animateWithDuration(duration, delay: delay, options: options, animations: {
          self.haikuLabel.frame.origin = slideInPosition
          self.haikuLabel.alpha = 1
          
          self.authorLabel.alpha = 1
          
          }, completion: completion)
        
    })
  }
  
  /**
   Hide credit labels
   */
  func hideCredits() {
    let duration: NSTimeInterval = 0.8
    let options = UIViewAnimationOptions.CurveEaseInOut
    let delay: NSTimeInterval = 0
    
    UIView.animateWithDuration(duration, delay: delay, options: options, animations: {
      self.haikuLabel.alpha = 0
      self.authorLabel.alpha = 0
      
      }, completion: {
        _ in
        self.haikuLabel.text = self.haiku.getHaikuLines()
        self.haikuLabel.font = UIFont(name: Font.Verdana, size: self.haikuTextFont)
        
        self.authorLabel.text = self.haiku.author
        
        UIView.animateWithDuration(duration, delay: delay, options: options, animations: {
          self.haikuLabel.alpha = 1
          self.authorLabel.alpha = 1
          
          }, completion: nil)
        
    })
  }
  
  /**
   Show credit labels
   */
  func showCredits() {
    let duration: NSTimeInterval = 0.8
    let options = UIViewAnimationOptions.CurveEaseInOut
    let delay: NSTimeInterval = 0
    
    UIView.animateWithDuration(duration, delay: delay, options: options, animations: {
      self.haikuLabel.alpha = 0
      self.authorLabel.alpha = 0
      
      }, completion: {
        _ in
        self.haikuLabel.text = "Arts by: Openclipart.org\n\nMusic by: Freesound.org"
        self.haikuLabel.font = UIFont(name: Font.Verdana, size: 30 * self.fontScale)
        
        self.authorLabel.text = ""
        
        UIView.animateWithDuration(duration, delay: delay, options: options, animations: {
          self.haikuLabel.alpha = 1
          self.authorLabel.alpha = 1
          
          }, completion: nil)
        
    })
  }
  
}

// MARK: - Screenshot Helper
extension ScrollingView {
  
  /**
   Get a screenshot UIImage of the view.
   
   - returns: screenshot of the view
   */
  func getScreenShot() -> UIImage {
    UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
    
    drawViewHierarchyInRect(frame, afterScreenUpdates: true
    )
    
    let screenShot = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return screenShot
  }
}























