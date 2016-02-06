//
//  ViewController.swift
//  EndlessHaiku
//
//  Created by Thinh Luong on 1/19/16.
//  Copyright © 2016 Thinh Luong. All rights reserved.
//

import UIKit
import QuartzCore
import AVFoundation

class ViewController: UIViewController {
  
  // MARK: Functions
  private func loadSpeechSynthesizerSettings() -> Bool {
    let defaults = NSUserDefaults.standardUserDefaults()
    if let rate = defaults.objectForKey("rate") as? Float, let pitch = defaults.objectForKey("pitch") as? Float, let volume = defaults.objectForKey("volume") as? Float {
      self.rate = rate
      self.pitch = pitch
      self.volume = volume
      
      return true
    } else {
      return false
    }
  }
  
  func registerDefaultSettings() {
    rate = AVSpeechUtteranceDefaultSpeechRate
    pitch = 1.0
    volume = 1.0
    
    let defaults: [String: AnyObject] = ["rate": rate, "pitch": pitch, "volume": volume]
    
    NSUserDefaults.standardUserDefaults().registerDefaults(defaults)
    
  }
  
  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    haikuManager = HaikuManager()
    
    scrollingView = ScrollingView(frame: view.frame)
    scrollingView.delegate = self
    
    currentHaiku = haikuManager.getRandomHaiku()
    scrollingView.haiku = currentHaiku
    
    view.addSubview(scrollingView)
    
    loadSwipeGestureRecognizers()
    
    speechSynthesizer = AVSpeechSynthesizer()
    speechSynthesizer.delegate = self
    
    if !loadSpeechSynthesizerSettings() {
      rate = AVSpeechUtteranceDefaultSpeechRate
      pitch = 1.0
      volume = 1.0
      
      registerDefaultSettings()
    }
  }
  
  override func viewWillAppear(animated: Bool) {
    navigationController?.navigationBarHidden = true
  }
  
  override func viewWillDisappear(animated: Bool) {
    navigationController?.navigationBarHidden = false
  }
  
  // MARK: Properties
  var speechSynthesizer: AVSpeechSynthesizer!
  var haikuManager: HaikuManager!
  var scrollingView: ScrollingView!
  var soundEnabled: Bool = false
  var currentHaiku: Haiku!
  
  var totalUtterances: Int = 0
  var currentUtterances: Int = 0
  var totalTextLength: Int = 0
  var spokenTextLength: Int = 0
  
  var rate: Float = 0
  var pitch: Float = 0
  var volume: Float = 0
}

extension ViewController: AVSpeechSynthesizerDelegate {
  
  func getSpeechUtterance(speech: String) -> AVSpeechUtterance {
    let speechUtterance = AVSpeechUtterance(string: speech)
    speechUtterance.rate = rate
    speechUtterance.pitchMultiplier = pitch
    speechUtterance.volume = volume
    speechUtterance.postUtteranceDelay = 0.005
    
    return speechUtterance
  }
  
  func speakHaiku() {
    if !speechSynthesizer.speaking {
      for line in currentHaiku.lines {
        let speechUtterance = getSpeechUtterance(line)
        speechSynthesizer.speakUtterance(speechUtterance)
      }
      
      let authorSpeechUtterance = getSpeechUtterance(currentHaiku.author)
      speechSynthesizer.speakUtterance(authorSpeechUtterance)
      
    } else {
      speechSynthesizer.continueSpeaking()
    }
  }
  
  func pauseSpeech() {
    speechSynthesizer.pauseSpeakingAtBoundary(.Word)
  }
  
  func stopSpeech() {
    speechSynthesizer.stopSpeakingAtBoundary(.Immediate)
  }
  
}

// MARK: - Swipe Gestures
extension ViewController {
  private func loadSwipeGestureRecognizers() {
    let swipeLeft = UISwipeGestureRecognizer(target: self, action: Selector("swipeLeft"))
    swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
    
    let swipeRight = UISwipeGestureRecognizer(target: self, action: Selector("swipeRight"))
    swipeRight.direction = UISwipeGestureRecognizerDirection.Right
    
    let swipeUp = UISwipeGestureRecognizer(target: self, action: Selector("swipeUp"))
    swipeUp.direction = UISwipeGestureRecognizerDirection.Up
    
    let swipeDown = UISwipeGestureRecognizer(target: self, action: Selector("swipeDown"))
    swipeDown.direction = UISwipeGestureRecognizerDirection.Down
    
    view.addGestureRecognizer(swipeLeft)
    view.addGestureRecognizer(swipeRight)
    view.addGestureRecognizer(swipeUp)
    view.addGestureRecognizer(swipeDown)
  }
  
  func swipeLeft() {
    stopSpeech()
    
    currentHaiku = haikuManager.getRandomHaiku()
    scrollingView.haiku = currentHaiku
    scrollingView.swipe(.Left) { _ in
      self.speakHaiku()
    }
  }
  
  func swipeRight() {
    stopSpeech()
    
    currentHaiku = haikuManager.getRandomHaiku()
    scrollingView.haiku = currentHaiku
    scrollingView.swipe(.Right) { _ in
      self.speakHaiku()
    }
    
  }
  
  func swipeUp() {
    stopSpeech()
    
    currentHaiku = haikuManager.getRandomHaiku()
    scrollingView.haiku = currentHaiku
    scrollingView.swipe(.Up) { _ in
      self.speakHaiku()
    }
    
  }
  
  func swipeDown() {
    stopSpeech()
    
    currentHaiku = haikuManager.getRandomHaiku()
    scrollingView.haiku = currentHaiku
    scrollingView.swipe(.Down) { _ in
      self.speakHaiku()
    }
    
  }
}

// MARK: - ScrollingViewDelegate
extension ViewController: ScrollingViewDelegate {
  func showAds() -> Bool {
    return true
  }
  
  var soundSelected: Bool {
    get {
      return soundEnabled
    }
    
    set {
      soundEnabled = soundSelected
    }
  }
  
  func showFacebook() {
    print("showFacebook")
  }
  
  func showTwitter() {
    print("showTwitter")
  }
  
  func removeAds() {
    print("removeAds")
  }
  
  func restorePurchases() {
    print("restorePurchases")
  }
  
  func rateApp() {
    print("rateApps")
  }
  
  func showSettings() {
    print("showSettings")
    
    let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
    if let settingsVC = mainStoryboard.instantiateViewControllerWithIdentifier("SettingsViewController") as? SettingsViewController {
      //      presentViewController(settingsVC, animated: true, completion: nil)
      
      stopSpeech()
      settingsVC.delegate = self
      navigationController?.pushViewController(settingsVC, animated: true)
      
    }
  }
}

extension ViewController: SettingsViewControllerDelegate {
  func didSaveSettings() {
    let defaults = NSUserDefaults.standardUserDefaults()
    rate = defaults.floatForKey("rate")
    pitch = defaults.floatForKey("pitch")
    volume = defaults.floatForKey("volume")
    
    speakHaiku()
  }
}































