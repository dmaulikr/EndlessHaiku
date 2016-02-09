//
//  FloatingMenuView.swift
//  EndlessHaiku
//
//  Created by Thinh Luong on 2/8/16.
//  Copyright © 2016 Thinh Luong. All rights reserved.
//

import UIKit

protocol FloatingMenuViewDelegate: class {
  func facebookButtonPressed()
  func twitterButtonPressed()
  func rateButtonPressed()
  func settingsButtonPressed()
  func removeAdsButtonPressed()
  func restorePurchaseButtonPressed()
  func creditsButtonPressed(state: Bool)
  
  var soundButtonSelected: Bool { get set }
  var adsButtonsEnabled: Bool { get }
}

class FloatingMenuView: UIView {
  
  // MARK: Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    buttonLayer = UIView(frame: frame)
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
  
  // MARK: Properties
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
  
  weak var delegate: FloatingMenuViewDelegate?
  
}

extension FloatingMenuView {
  private func loadMenuButton() {
    if let menuShow = getScaledImage("UIButtons_MenuShow", scale: CGPoint(x: 0.8, y: 0.8)), let menuHide = getScaledImage("UIButtons_MenuHide", scale: CGPoint(x: 0.8, y: 0.8)) {
      
      let xPosition = menuShow.size.width * 0.1
      let yPosition = menuShow.size.width * 0.1
      menuButton = UIButton(frame: CGRect(x: xPosition, y: yPosition, width: menuShow.size.width, height: menuShow.size.height))
      menuButton.setImage(menuShow, forState: UIControlState.Normal)
      menuButton.setImage(menuHide, forState: UIControlState.Selected)
      
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
}

// MARK: Button Selectors
extension FloatingMenuView {
  func creditsButtonPress() {
    creditsButton.transform = CGAffineTransformMakeScale(1.1, 1.1)
  }
  
  func creditsButtonRelease() {
    
    creditsButton.selected = !creditsButton.selected
    
    delegate?.creditsButtonPressed(creditsButton.selected)
    
    creditsButton.transform = CGAffineTransformMakeScale(1.0, 1.0)
  }
  
  func removeAdsButtonPress() {
    removeAdsButton?.transform = CGAffineTransformMakeScale(1.1, 1.1)
  }
  
  func removeAdsButtonRelease() {
    removeAdsButton?.transform = CGAffineTransformMakeScale(1.0, 1.0)
    delegate?.removeAdsButtonPressed()
  }
  
  func restorePurchaseButtonPress() {
    restorePurchaseButton?.transform = CGAffineTransformMakeScale(1.1, 1.1)
  }
  
  func restorePurchaseButtonRelease() {
    restorePurchaseButton?.transform = CGAffineTransformMakeScale(1.0, 1.0)
    delegate?.restorePurchaseButtonPressed()
  }
  
  func rateButtonPress() {
    rateButton.transform = CGAffineTransformMakeScale(1.1, 1.1)
  }
  
  func rateButtonRelease() {
    rateButton.transform = CGAffineTransformMakeScale(1.0, 1.0)
    delegate?.rateButtonPressed()
  }
  
  func facebookButtonPress() {
    facebookButton.transform = CGAffineTransformMakeScale(1.1, 1.1)
  }
  
  func facebookButtonRelease() {
    facebookButton.transform = CGAffineTransformMakeScale(1.0, 1.0)
    delegate?.facebookButtonPressed()
  }
  
  func twitterButtonPress() {
    twitterButton.transform = CGAffineTransformMakeScale(1.1, 1.1)
  }
  
  func twitterButtonRelease() {
    twitterButton.transform = CGAffineTransformMakeScale(1.0, 1.0)
    delegate?.twitterButtonPressed()
  }
  
  func settingsButtonPress() {
    settingsButton.transform = CGAffineTransformMakeScale(1.1, 1.1)
  }
  
  func settingsButtonRelease() {
    settingsButton.transform = CGAffineTransformMakeScale(1.0, 1.0)
    delegate?.settingsButtonPressed()
  }
  
  func soundButtonPress() {
    soundButton.transform = CGAffineTransformMakeScale(1.1, 1.1)
  }
  
  func soundButtonRelease() {
    if let delegate = delegate {
      soundButton.selected = !soundButton.selected
      delegate.soundButtonSelected = soundButton.selected
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


extension FloatingMenuView {
  
  private func fadeOutButtonLayer() {
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
  
  private func fadeInButtonLayer() {
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
      
      if let delegate = self.delegate where delegate.adsButtonsEnabled {
        self.removeAdsButton?.layer.opacity = 1
        self.removeAdsButton?.frame.origin.x = self.bounds.size.width - self.menuButton.frame.maxX * 2
        
        self.restorePurchaseButton?.layer.opacity = 1
        self.restorePurchaseButton?.frame.origin.x = self.bounds.size.width - self.menuButton.frame.maxX * 1
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



























