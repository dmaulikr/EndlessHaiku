//
//  ScrollingView.swift
//  EndlessHaiku
//
//  Created by Thinh Luong on 1/20/16.
//  Copyright © 2016 Thinh Luong. All rights reserved.
//

import UIKit

protocol ScrollingViewDelegate: class {
  func rateApp()
  func showFacebook()
  func showTwitter()
  func removeAds()
  func restorePurchases()
  func showSettings()
  func showAds() -> Bool
  
  var soundSelected: Bool {get set}
}

class ScrollingView: UIView {
  
  weak var delegate: ScrollingViewDelegate?
  
  var haiku: Haiku!
  var haikuLabel = UILabel()
  var authorLabel = UILabel()
  var buttonLayer = UIView()
  var soundButton = UIButton()
  var menuButton = UIButton()
  var facebookButton = UIButton()
  var twitterButton = UIButton()
  var creditsButton = UIButton()
  var rateButton = UIButton()
  var settingsButton = UIButton()
  var removeAdsButton: UIButton?
  var restorePurchaseButton: UIButton?
  
  var translation: CGFloat = 0
  var scrollDirection = Direction.Right
  let scrollSpeed: CGFloat = 0.1
  
  enum Direction: CGFloat {
    case Left = -1, Right = 1, Up, Down
  }
  
  struct Layer {
    static let Background: CGFloat = 0
    static let ScrollLayer: CGFloat = 1
    static let Label: CGFloat = 2
    static let Button: CGFloat = 3
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
  
  
  var quoteTextFont: CGFloat {
    get {
      
      //      var baseSize: CGFloat
      //      switch currentQuote.quote.characters.count {
      //      case 0...50:
      //        baseSize = 30
      //      case 51...100:
      //        baseSize = 24
      //      case 101...200:
      //        baseSize = 20
      //      case 201...1000:
      //        baseSize = 18
      //      default:
      //        baseSize = 30
      //      }
      //      
      //      return baseSize * fontScale
      
      return 30
    }
  }
  
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
        return 1.5
      case .iPad:
        return 2
      }
    }
  }
  
  
  
  // MARK: Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    loadBackground()
    loadLabels()
    
    buttonLayer = UIView(frame: frame)
    buttonLayer.layer.zPosition = Layer.Button
    addSubview(buttonLayer)
    
    loadMenuButton()
    
    loadFacebookButton()
    loadTwitterButton()
    loadCreditsButton()
    
    loadRemoveAdsButton()
    loadRestorePurchaseButton()
    
    loadRateButton()
    loadSoundButton()
    loadSettingsButton()
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Display
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
  
  private func pauseDisplayLink() {
    displayLink.paused = true
  }
  
  private func resumeDisplayLink() {
    displayLink.paused = false
  }
  
}

// MARK: Loading
extension ScrollingView {
  
  private func loadBackground() {
    
    if let image = mountFuji {
      let layer = CALayer()
      layer.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
      layer.zPosition = Layer.Background
      layer.contents = image.CGImage
      
      scrollLayer.zPosition = Layer.ScrollLayer
      self.layer.addSublayer(scrollLayer)
      scrollLayer.addSublayer(layer)
      
      displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
    }
  }
  
  private func loadMenuButton() {
    if let menuShow = getScaledImage("UIButtons_MenuShow", scale: CGPoint(x: 0.8, y: 0.8)), let menuHide = getScaledImage("UIButtons_MenuHide", scale: CGPoint(x: 0.8, y: 0.8)) {
      
      let xPosition = menuShow.size.width * 0.1
      let yPosition = menuShow.size.width * 0.1
      menuButton = UIButton(frame: CGRect(x: xPosition, y: yPosition, width: menuShow.size.width, height: menuShow.size.height))
      menuButton.setImage(menuShow, forState: UIControlState.Normal)
      menuButton.setImage(menuHide, forState: UIControlState.Selected)
      
      
      menuButton.layer.zPosition = Layer.Button
      buttonLayer.addSubview(menuButton)
      
      menuButton.addTarget(self, action: "menuButtonPress", forControlEvents: UIControlEvents.TouchDown)
      menuButton.addTarget(self, action: "menuButtonRelease", forControlEvents: UIControlEvents.TouchUpInside)
      menuButton.addTarget(self, action: "menuButtonRelease", forControlEvents: UIControlEvents.TouchUpOutside)
      menuButton.addTarget(self, action: "menuButtonRelease", forControlEvents: UIControlEvents.TouchCancel)
      menuButton.addTarget(self, action: "menuButtonRelease", forControlEvents: UIControlEvents.TouchDragExit)
    }
  }
  
  private func loadFacebookButton() {
    if let image = getScaledImage("UIButtons_Facebook", scale: CGPoint(x: 0.8, y: 0.8)) {
      
      let xPosition = menuButton.frame.origin.x
      let yPosition = menuButton.frame.origin.y
      facebookButton = UIButton(frame: CGRect(x: xPosition, y: yPosition, width: image.size.width, height: image.size.height))
      facebookButton.setImage(image, forState: UIControlState.Normal)
      
      facebookButton.layer.zPosition = Layer.Button
      facebookButton.layer.opacity = 0
      facebookButton.userInteractionEnabled = false
      
      buttonLayer.addSubview(facebookButton)
      
      facebookButton.addTarget(self, action: "facebookButtonPress", forControlEvents: UIControlEvents.TouchDown)
      facebookButton.addTarget(self, action: "facebookButtonRelease", forControlEvents: UIControlEvents.TouchUpInside)
      facebookButton.addTarget(self, action: "facebookButtonRelease", forControlEvents: UIControlEvents.TouchUpOutside)
      facebookButton.addTarget(self, action: "facebookButtonRelease", forControlEvents: UIControlEvents.TouchCancel)
      facebookButton.addTarget(self, action: "facebookButtonRelease", forControlEvents: UIControlEvents.TouchDragExit)
    }
  }
  
  private func loadTwitterButton() {
    if let image = getScaledImage("UIButtons_Twitter", scale: CGPoint(x: 0.8, y: 0.8)) {
      
      let xPosition = menuButton.frame.origin.x
      let yPosition = menuButton.frame.origin.y
      twitterButton = UIButton(frame: CGRect(x: xPosition, y: yPosition, width: image.size.width, height: image.size.height))
      twitterButton.setImage(image, forState: UIControlState.Normal)
      
      twitterButton.layer.zPosition = Layer.Button
      twitterButton.layer.opacity = 0
      twitterButton.userInteractionEnabled = false
      
      buttonLayer.addSubview(twitterButton)
      
      twitterButton.addTarget(self, action: "twitterButtonPress", forControlEvents: UIControlEvents.TouchDown)
      twitterButton.addTarget(self, action: "twitterButtonRelease", forControlEvents: UIControlEvents.TouchUpInside)
      twitterButton.addTarget(self, action: "twitterButtonRelease", forControlEvents: UIControlEvents.TouchUpOutside)
      twitterButton.addTarget(self, action: "twitterButtonRelease", forControlEvents: UIControlEvents.TouchCancel)
      twitterButton.addTarget(self, action: "twitterButtonRelease", forControlEvents: UIControlEvents.TouchDragExit)
    }
  }
  
  private func loadCreditsButton() {
    if let image = getScaledImage("UIButtons_Credits", scale: CGPoint(x: 0.8, y: 0.8)) {
      
      let xPosition = menuButton.frame.origin.x
      let yPosition = menuButton.frame.origin.y
      creditsButton = UIButton(frame: CGRect(x: xPosition, y: yPosition, width: image.size.width, height: image.size.height))
      creditsButton.setImage(image, forState: UIControlState.Normal)
      
      creditsButton.layer.zPosition = Layer.Button
      creditsButton.layer.opacity = 0
      creditsButton.userInteractionEnabled = false
      
      buttonLayer.addSubview(creditsButton)
      
      creditsButton.addTarget(self, action: "creditsButtonPress", forControlEvents: UIControlEvents.TouchDown)
      creditsButton.addTarget(self, action: "creditsButtonRelease", forControlEvents: UIControlEvents.TouchUpInside)
      creditsButton.addTarget(self, action: "creditsButtonRelease", forControlEvents: UIControlEvents.TouchUpOutside)
      creditsButton.addTarget(self, action: "creditsButtonRelease", forControlEvents: UIControlEvents.TouchCancel)
      creditsButton.addTarget(self, action: "creditsButtonRelease", forControlEvents: UIControlEvents.TouchDragExit)
    }
  }
  
  private func loadRateButton() {
    if let image = getScaledImage("UIButtons_Rate", scale: CGPoint(x: 0.8, y: 0.8)) {
      
      let xPosition = menuButton.frame.origin.x
      let yPosition = menuButton.frame.origin.y
      rateButton = UIButton(frame: CGRect(x: xPosition, y: yPosition, width: image.size.width, height: image.size.height))
      rateButton.setImage(image, forState: UIControlState.Normal)
      
      rateButton.layer.zPosition = Layer.Button
      rateButton.layer.opacity = 0
      rateButton.userInteractionEnabled = false
      
      buttonLayer.addSubview(rateButton)
      
      rateButton.addTarget(self, action: "rateButtonPress", forControlEvents: UIControlEvents.TouchDown)
      rateButton.addTarget(self, action: "rateButtonRelease", forControlEvents: UIControlEvents.TouchUpInside)
      rateButton.addTarget(self, action: "rateButtonRelease", forControlEvents: UIControlEvents.TouchUpOutside)
      rateButton.addTarget(self, action: "rateButtonRelease", forControlEvents: UIControlEvents.TouchCancel)
      rateButton.addTarget(self, action: "rateButtonRelease", forControlEvents: UIControlEvents.TouchDragExit)
    }
  }
  
  private func loadRemoveAdsButton() {
    if let image = getScaledImage("UIButtons_RemoveAds", scale: CGPoint(x: 0.8, y: 0.8)) {
      
      let xPosition = menuButton.frame.origin.x
      let yPosition = menuButton.frame.origin.y
      removeAdsButton = UIButton(frame: CGRect(x: xPosition, y: yPosition, width: image.size.width, height: image.size.height))
      removeAdsButton?.setImage(image, forState: UIControlState.Normal)
      
      removeAdsButton?.layer.zPosition = Layer.Button
      removeAdsButton?.layer.opacity = 0
      removeAdsButton?.userInteractionEnabled = false
      
      buttonLayer.addSubview(removeAdsButton!)
      
      removeAdsButton?.addTarget(self, action: "removeAdsButtonPress", forControlEvents: UIControlEvents.TouchDown)
      removeAdsButton?.addTarget(self, action: "removeAdsButtonRelease", forControlEvents: UIControlEvents.TouchUpInside)
      removeAdsButton?.addTarget(self, action: "removeAdsButtonRelease", forControlEvents: UIControlEvents.TouchUpOutside)
      removeAdsButton?.addTarget(self, action: "removeAdsButtonRelease", forControlEvents: UIControlEvents.TouchCancel)
      removeAdsButton?.addTarget(self, action: "removeAdsButtonRelease", forControlEvents: UIControlEvents.TouchDragExit)
    }
  }
  
  private func loadRestorePurchaseButton() {
    if let image = getScaledImage("UIButtons_RestorePurchase", scale: CGPoint(x: 0.8, y: 0.8)) {
      
      let xPosition = menuButton.frame.origin.x
      let yPosition = menuButton.frame.origin.y
      restorePurchaseButton = UIButton(frame: CGRect(x: xPosition, y: yPosition, width: image.size.width, height: image.size.height))
      restorePurchaseButton?.setImage(image, forState: UIControlState.Normal)
      
      restorePurchaseButton?.layer.zPosition = Layer.Button
      restorePurchaseButton?.layer.opacity = 0
      restorePurchaseButton?.userInteractionEnabled = false
      
      buttonLayer.addSubview(restorePurchaseButton!)
      
      restorePurchaseButton?.addTarget(self, action: "restorePurchaseButtonPress", forControlEvents: UIControlEvents.TouchDown)
      restorePurchaseButton?.addTarget(self, action: "restorePurchaseButtonRelease", forControlEvents: UIControlEvents.TouchUpInside)
      restorePurchaseButton?.addTarget(self, action: "restorePurchaseButtonRelease", forControlEvents: UIControlEvents.TouchUpOutside)
      restorePurchaseButton?.addTarget(self, action: "restorePurchaseButtonRelease", forControlEvents: UIControlEvents.TouchCancel)
      restorePurchaseButton?.addTarget(self, action: "restorePurchaseButtonRelease", forControlEvents: UIControlEvents.TouchDragExit)
    }
  }
  
  private func loadSoundButton() {
    
    if let soundOn = getScaledImage("UIButtons_SoundOn", scale: CGPoint(x: 0.8, y: 0.8)), let soundOff = getScaledImage("UIButtons_SoundOff", scale: CGPoint(x: 0.8, y: 0.8)) {
      
      let xPosition = menuButton.frame.origin.x
      let yPosition = menuButton.frame.origin.y
      soundButton = UIButton(frame: CGRect(x: xPosition, y: yPosition, width: soundOn.size.width, height: soundOn.size.height))
      soundButton.setImage(soundOn, forState: UIControlState.Normal)
      soundButton.setImage(soundOff, forState: UIControlState.Selected)
      
      soundButton.layer.zPosition = Layer.Button
      soundButton.layer.opacity = 0
      soundButton.userInteractionEnabled = false
      
      buttonLayer.addSubview(soundButton)
      
      soundButton.addTarget(self, action: "soundButtonPress", forControlEvents: UIControlEvents.TouchDown)
      soundButton.addTarget(self, action: "soundButtonRelease", forControlEvents: UIControlEvents.TouchUpInside)
      soundButton.addTarget(self, action: "soundButtonRelease", forControlEvents: UIControlEvents.TouchUpOutside)
      soundButton.addTarget(self, action: "soundButtonRelease", forControlEvents: UIControlEvents.TouchCancel)
      soundButton.addTarget(self, action: "soundButtonRelease", forControlEvents: UIControlEvents.TouchDragExit)
      
    }
  }
  
  private func loadSettingsButton() {
    
    if let image = getScaledImage("UIButtons_Settings", scale: CGPoint(x: 0.8, y: 0.8)){
      
      let xPosition = menuButton.frame.origin.x
      let yPosition = menuButton.frame.origin.y
      settingsButton = UIButton(frame: CGRect(x: xPosition, y: yPosition, width: image.size.width, height: image.size.height))
      settingsButton.setImage(image, forState: UIControlState.Normal)
      
      settingsButton.layer.zPosition = Layer.Button
      settingsButton.layer.opacity = 0
      settingsButton.userInteractionEnabled = false
      
      buttonLayer.addSubview(settingsButton)
      
      settingsButton.addTarget(self, action: "settingsButtonPress", forControlEvents: UIControlEvents.TouchDown)
      settingsButton.addTarget(self, action: "settingsButtonRelease", forControlEvents: UIControlEvents.TouchUpInside)
      settingsButton.addTarget(self, action: "settingsButtonRelease", forControlEvents: UIControlEvents.TouchUpOutside)
      settingsButton.addTarget(self, action: "settingsButtonRelease", forControlEvents: UIControlEvents.TouchCancel)
      settingsButton.addTarget(self, action: "settingsButtonRelease", forControlEvents: UIControlEvents.TouchDragExit)
      
    }
  }
  
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
    haikuLabel.layer.zPosition = Layer.Label
    
    haikuLabel.adjustsFontSizeToFitWidth = true
    haikuLabel.minimumScaleFactor = 0.2
    
    addSubview(haikuLabel)
    
    authorLabel = UILabel(frame: CGRect(x: bounds.size.width * 0.5, y: bounds.size.height * 0.8, width: bounds.size.width * 0.5, height: bounds.size.height * 0.1))
    authorLabel.lineBreakMode = .ByWordWrapping
    authorLabel.numberOfLines = 0
    authorLabel.textAlignment = NSTextAlignment.Center
    authorLabel.font = UIFont(name: Font.Verdana, size: 14 * fontScale)
    authorLabel.backgroundColor = UIColor.clearColor()
    authorLabel.textColor = UIColor.whiteColor()
    authorLabel.layer.zPosition = Layer.Label
    
    authorLabel.adjustsFontSizeToFitWidth = true
    authorLabel.minimumScaleFactor = 0.2
    
    addSubview(authorLabel)
    
    haikuLabel.text = "Swipe"
    authorLabel.text = ""
  }
  
}

// MARK: Button Selectors
extension ScrollingView {
  func creditsButtonPress() {
    creditsButton.transform = CGAffineTransformMakeScale(1.1, 1.1)
  }
  
  func creditsButtonRelease() {
    
    creditsButton.selected = !creditsButton.selected
    
    if creditsButton.selected {
      showCredits()
    } else {
      hideCredits()
    }
    
    creditsButton.transform = CGAffineTransformMakeScale(1.0, 1.0)
  }
  
  func removeAdsButtonPress() {
    removeAdsButton?.transform = CGAffineTransformMakeScale(1.1, 1.1)
  }
  
  func removeAdsButtonRelease() {
    removeAdsButton?.transform = CGAffineTransformMakeScale(1.0, 1.0)
    delegate?.removeAds()
  }
  
  func restorePurchaseButtonPress() {
    restorePurchaseButton?.transform = CGAffineTransformMakeScale(1.1, 1.1)
  }
  
  func restorePurchaseButtonRelease() {
    restorePurchaseButton?.transform = CGAffineTransformMakeScale(1.0, 1.0)
    delegate?.restorePurchases()
  }
  
  func rateButtonPress() {
    rateButton.transform = CGAffineTransformMakeScale(1.1, 1.1)
  }
  
  func rateButtonRelease() {
    rateButton.transform = CGAffineTransformMakeScale(1.0, 1.0)
    delegate?.rateApp()
  }
  
  func facebookButtonPress() {
    facebookButton.transform = CGAffineTransformMakeScale(1.1, 1.1)
  }
  
  func facebookButtonRelease() {
    facebookButton.transform = CGAffineTransformMakeScale(1.0, 1.0)
    delegate?.showFacebook()
  }
  
  func twitterButtonPress() {
    twitterButton.transform = CGAffineTransformMakeScale(1.1, 1.1)
  }
  
  func twitterButtonRelease() {
    twitterButton.transform = CGAffineTransformMakeScale(1.0, 1.0)
    delegate?.showTwitter()
  }
  
  func settingsButtonPress() {
    settingsButton.transform = CGAffineTransformMakeScale(1.1, 1.1)
  }
  
  func settingsButtonRelease() {
    settingsButton.transform = CGAffineTransformMakeScale(1.0, 1.0)
    delegate?.showSettings()
  }
  
  func soundButtonPress() {
    soundButton.transform = CGAffineTransformMakeScale(1.1, 1.1)
  }
  
  func soundButtonRelease() {
    if let delegate = delegate {
      soundButton.selected = !soundButton.selected
      delegate.soundSelected = soundButton.selected
    }
    
    soundButton.transform = CGAffineTransformMakeScale(1.0, 1.0)
    
  }
  
  func menuButtonPress() {
    menuButton.transform = CGAffineTransformMakeScale(1.1, 1.1)
  }
  
  func menuButtonRelease() {
    menuButton.selected = !menuButton.selected
    
    if menuButton.selected {
      showButtons()
    } else {
      hideButtons()
    }
    
    menuButton.transform = CGAffineTransformMakeScale(1.0, 1.0)
    
  }
  
}

// MARK: Button Actions
extension ScrollingView {
  
  func swipe(direction: Direction, completion: (Bool)->Void) {
    
    creditsButton.selected = false
    
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
        self.haikuLabel.font = UIFont(name: Font.Verdana, size: self.quoteTextFont)
        
        self.authorLabel.text = self.haiku.author
        
        UIView.animateWithDuration(duration, delay: delay, options: options, animations: {
          self.haikuLabel.frame.origin = slideInPosition
          self.haikuLabel.alpha = 1
          
          self.authorLabel.alpha = 1
          
          }, completion: completion)
        
    })
  }
  
  private func hideCredits() {
    let duration: NSTimeInterval = 0.8
    let options = UIViewAnimationOptions.CurveEaseInOut
    let delay: NSTimeInterval = 0
    
    UIView.animateWithDuration(duration, delay: delay, options: options, animations: {
      self.haikuLabel.alpha = 0
      self.authorLabel.alpha = 0
      
      }, completion: {
        _ in
        self.haikuLabel.text = self.haiku.getHaikuLines()
        self.haikuLabel.font = UIFont(name: Font.Verdana, size: self.quoteTextFont)
        
        self.authorLabel.text = self.haiku.author
        
        UIView.animateWithDuration(duration, delay: delay, options: options, animations: {
          self.haikuLabel.alpha = 1
          self.authorLabel.alpha = 1
          
          }, completion: nil)
        
    })
  }
  
  private func showCredits() {
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
  
  func fadeOutButtonLayer() {
    let duration: NSTimeInterval = 0.4
    let options = UIViewAnimationOptions.CurveEaseInOut
    let delay: NSTimeInterval = 0
    
    UIView.animateWithDuration(duration, delay: delay, options: options, animations: {
      self.buttonLayer.layer.opacity = 0
      
      }, completion: {
        _ in
        self.buttonLayer.userInteractionEnabled = false
        
    })
  }
  
  func fadeInButtonLayer() {
    let duration: NSTimeInterval = 0.4
    let options = UIViewAnimationOptions.CurveEaseInOut
    let delay: NSTimeInterval = 0
    
    UIView.animateWithDuration(duration, delay: delay, options: options, animations: {
      self.buttonLayer.layer.opacity = 1
      
      }, completion: {
        _ in
        self.buttonLayer.userInteractionEnabled = true
        
    })
  }
  
  private func showButtons() {
    let duration: NSTimeInterval = 0.8
    let options = UIViewAnimationOptions.CurveEaseInOut
    let delay: NSTimeInterval = 0
    
    UIView.animateWithDuration(duration, delay: delay, options: options, animations: {
      self.facebookButton.layer.opacity = 1
      self.facebookButton.frame.origin.x = self.menuButton.frame.maxX * 1
      
      self.twitterButton.layer.opacity = 1
      self.twitterButton.frame.origin.x = self.menuButton.frame.maxX * 2
      
      self.rateButton.layer.opacity = 1
      self.rateButton.frame.origin.x = self.menuButton.frame.maxX * 3
      
      self.creditsButton.layer.opacity = 1
      self.creditsButton.frame.origin.x = self.menuButton.frame.maxX * 4
      
      self.soundButton.layer.opacity = 1
      self.soundButton.frame.origin.x = self.menuButton.frame.maxX * 5
      
      self.settingsButton.layer.opacity = 1
      self.settingsButton.frame.origin.x = self.menuButton.frame.maxX * 6
      
      if let delegate = self.delegate {
        if delegate.showAds() {
          self.removeAdsButton?.layer.opacity = 1
          self.removeAdsButton?.frame.origin.x = self.bounds.size.width - self.menuButton.frame.maxX * 2
          
          self.restorePurchaseButton?.layer.opacity = 1
          self.restorePurchaseButton?.frame.origin.x = self.bounds.size.width - self.menuButton.frame.maxX * 1
        }
      }
      
      }, completion: {
        _ in
        self.facebookButton.userInteractionEnabled = true
        self.twitterButton.userInteractionEnabled = true
        self.rateButton.userInteractionEnabled = true
        self.creditsButton.userInteractionEnabled = true
        self.soundButton.userInteractionEnabled = true
        self.removeAdsButton?.userInteractionEnabled = true
        self.restorePurchaseButton?.userInteractionEnabled = true
        self.settingsButton.userInteractionEnabled = true
        
        
    })
  }
  
  private func hideButtons() {
    let duration: NSTimeInterval = 0.8
    let options = UIViewAnimationOptions.CurveEaseInOut
    let delay: NSTimeInterval = 0
    
    UIView.animateWithDuration(duration, delay: delay, options: options, animations: {
      self.facebookButton.layer.opacity = 0
      self.facebookButton.frame.origin.x = self.menuButton.frame.minX
      
      self.twitterButton.layer.opacity = 0
      self.twitterButton.frame.origin.x = self.menuButton.frame.minX
      
      self.rateButton.layer.opacity = 0
      self.rateButton.frame.origin.x = self.menuButton.frame.minX
      
      self.creditsButton.layer.opacity = 0
      self.creditsButton.frame.origin.x = self.menuButton.frame.minX
      
      self.soundButton.layer.opacity = 0
      self.soundButton.frame.origin.x = self.menuButton.frame.minX
      
      self.settingsButton.layer.opacity = 0
      self.settingsButton.frame.origin.x = self.menuButton.frame.minX
      
      self.removeAdsButton?.layer.opacity = 0
      self.removeAdsButton?.frame.origin.x = self.menuButton.frame.minX
      
      self.restorePurchaseButton?.layer.opacity = 0
      self.restorePurchaseButton?.frame.origin.x = self.menuButton.frame.minX
      
      }, completion: {
        _ in
        self.facebookButton.userInteractionEnabled = false
        self.twitterButton.userInteractionEnabled = false
        self.rateButton.userInteractionEnabled = false
        self.creditsButton.userInteractionEnabled = false
        self.soundButton.userInteractionEnabled = false
        self.removeAdsButton?.userInteractionEnabled = false
        self.restorePurchaseButton?.userInteractionEnabled = false
        
        
    })
  }
}

// MARK: Helpers
extension ScrollingView {
  private func getScaledImage(named: String, scale: CGPoint) -> UIImage? {
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
  
  private func getScaledImageForiPhone6(named: String) -> UIImage? {
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
  
}

























