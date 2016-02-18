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
import Social
import Crashlytics
import MoPub

class ViewController: UIViewController {
  
  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    haikuManager = HaikuManager()
    
    scrollingView = ScrollingView(frame: view.frame)
    
    currentHaiku = haikuManager.getRandomHaiku()
    scrollingView.haiku = currentHaiku
    
    view.addSubview(scrollingView)
    
    floatingMenuView = FloatingMenuView(frame: view.frame)
    floatingMenuView.delegate = self
    view.addSubview(floatingMenuView)
    
    loadSwipeGestureRecognizers()
    
    speechSynthesizer = AVSpeechSynthesizer()
    speechSynthesizer.delegate = self
    
    if !loadSpeechSynthesizerSettings() {
      rate = AVSpeechUtteranceDefaultSpeechRate
      pitch = 1.0
      volume = 1.0
      
      registerDefaultSettings()
    }
    
    loadAdView()
  }
  
  override func viewWillAppear(animated: Bool) {
    navigationController?.navigationBarHidden = true
  }
  
  override func viewWillDisappear(animated: Bool) {
    navigationController?.navigationBarHidden = false
  }
  
  // MARK: Properties
  let defaults = NSUserDefaults.standardUserDefaults()
  
  var speechSynthesizer: AVSpeechSynthesizer!
  var haikuManager: HaikuManager!
  var scrollingView: ScrollingView!
  var floatingMenuView: FloatingMenuView!
  var soundEnabled: Bool = false
  var currentHaiku: Haiku!
  
  var preferredVoiceLanguageCode: String!
  var preferredVoiceLanguageCodeIndex: Int!
  
  //  var totalUtterances: Int = 0
  //  var currentUtterances: Int = 0
  //  var totalTextLength: Int = 0
  //  var spokenTextLength: Int = 0
  
  var rate: Float = 0
  var pitch: Float = 0
  var volume: Float = 0
  
  var adView = MPAdView()
}

// MARK: - AVSpeechSynthesizerDelegate
extension ViewController: AVSpeechSynthesizerDelegate {
  
  /**
   Get AVSpeechUtterance from input message
   
   - parameter speech: message
   
   - returns: speech utterance
   */
  func getSpeechUtterance(speech: String) -> AVSpeechUtterance {
    let speechUtterance = AVSpeechUtterance(string: speech)
    speechUtterance.rate = rate
    speechUtterance.pitchMultiplier = pitch
    speechUtterance.volume = volume
    speechUtterance.postUtteranceDelay = 0.005
    
    if let voiceLanguageCode = preferredVoiceLanguageCode {
      let voice = AVSpeechSynthesisVoice(language: voiceLanguageCode)
      speechUtterance.voice = voice
    }
    
    return speechUtterance
  }
  
  /**
   Read current haiku using speechSynthesizer
   */
  func speakHaiku() {
    if !speechSynthesizer.speaking {
      for line in currentHaiku.lines {
        let speechUtterance = getSpeechUtterance(line)
        speechSynthesizer.speakUtterance(speechUtterance)
        
      }
      
      //      let authorSpeechUtterance = getSpeechUtterance(currentHaiku.author)
      //      speechSynthesizer.speakUtterance(authorSpeechUtterance)
      
    } else {
      speechSynthesizer.continueSpeaking()
    }
  }
  
  /**
   Pause speechSynthesizer
   */
  func pauseSpeech() {
    speechSynthesizer.pauseSpeakingAtBoundary(.Word)
  }
  
  /**
   Stop speechSynthesizer
   */
  func stopSpeech() {
    speechSynthesizer.stopSpeakingAtBoundary(.Word)
  }
  
  /**
   Load speechSynthesizer settings from NSUserDefaults
   
   - returns: success or failure in loading settings
   */
  func loadSpeechSynthesizerSettings() -> Bool {
    if let rate = defaults.objectForKey(UserDefaultsKey.rate) as? Float,
      let pitch = defaults.objectForKey(UserDefaultsKey.pitch) as? Float,
      let volume = defaults.objectForKey(UserDefaultsKey.volume) as? Float,
      let preferredVoiceLanguageCode = defaults.valueForKey(UserDefaultsKey.languageCode) as? String,
      let preferredVoiceLanguageCodeIndex = defaults.objectForKey(UserDefaultsKey.languageCodeIndex) as? Int {
        
        self.rate = rate
        self.pitch = pitch
        self.volume = volume
        
        self.preferredVoiceLanguageCode = preferredVoiceLanguageCode
        self.preferredVoiceLanguageCodeIndex = preferredVoiceLanguageCodeIndex
        
        return true
    } else {
      return false
    }
  }
  
  /**
   Set speechSynthesizer default settings
   */
  func registerDefaultSettings() {
    rate = AVSpeechUtteranceDefaultSpeechRate
    pitch = 1.0
    volume = 1.0
    preferredVoiceLanguageCode = "en-US"
    preferredVoiceLanguageCodeIndex = 8
    
    defaults.setFloat(rate, forKey: UserDefaultsKey.rate)
    defaults.setFloat(pitch, forKey: UserDefaultsKey.pitch)
    defaults.setFloat(volume, forKey: UserDefaultsKey.volume)
    
    defaults.synchronize()
    
  }
  
}


extension ViewController: MPAdViewDelegate {
  private func loadAdView() {
    let adUnitId = "b1be0fb3c7d84654bad790f005a50af7"
    adView = MPAdView(adUnitId: adUnitId, size: CGSize.zero)
    
    adView.delegate = self
    
    let bannerWidth = MOPUB_BANNER_SIZE.width
    let bannerHeight = MOPUB_BANNER_SIZE.height
    let xPosition = (view.bounds.size.width - bannerWidth) / 2
    let yPosition = view.bounds.size.height - bannerHeight
    
    
    // Positions the ad at the bottom, with the correct size
    adView.frame = CGRect(x: xPosition, y: yPosition, width: bannerWidth, height: bannerHeight)
    view.addSubview(adView)
    
    // Loads the ad over the network
    adView.loadAd()
    
  }
  
  func viewControllerForPresentingModalView() -> UIViewController! {
    return self
  }
}


// MARK: - Crashlytics
extension ViewController {
  private func loadCrashlyticsButton() {
    let button = UIButton(type: UIButtonType.RoundedRect)
    button.frame = CGRectMake(20, 50, 100, 30)
    button.setTitle("Crash", forState: UIControlState.Normal)
    button.addTarget(self, action: "crashButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
    view.addSubview(button)
  }
  
  @IBAction func crashButtonTapped(sender: AnyObject) {
    Crashlytics.sharedInstance().crash()
  }
  
}

// MARK: - Swipe Gestures
extension ViewController {
  /**
   Load swipe gestures
   */
  func loadSwipeGestureRecognizers() {
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
  
  /**
   Reset animations, speechSynthesizer, and haiku.
   */
  func hideCreditStopSpeechGetRandomHaiku() {
    floatingMenuView.creditsButton.selected = false
    stopSpeech()
    
    currentHaiku = haikuManager.getRandomHaiku()
    scrollingView.haiku = currentHaiku
  }
  
  func swipeLeft() {
    
    guard !speechSynthesizer.speaking else {
      return
    }
    
    hideCreditStopSpeechGetRandomHaiku()
    
    scrollingView.swipe(.Left) { _ in
      self.speakHaiku()
    }
  }
  
  func swipeRight() {
    
    guard !speechSynthesizer.speaking else {
      return
    }
    
    hideCreditStopSpeechGetRandomHaiku()
    
    scrollingView.swipe(.Right) { _ in
      self.speakHaiku()
    }
    
  }
  
  func swipeUp() {
    
    guard !speechSynthesizer.speaking else {
      return
    }
    
    hideCreditStopSpeechGetRandomHaiku()
    
    scrollingView.swipe(.Up) { _ in
      self.speakHaiku()
    }
    
  }
  
  func swipeDown() {
    
    guard !speechSynthesizer.speaking else {
      return
    }
    
    hideCreditStopSpeechGetRandomHaiku()
    
    scrollingView.swipe(.Down) { _ in
      self.speakHaiku()
    }
    
  }
}


extension ViewController {
  /**
   Show Facebook compost view.
   */
  func showFacebook() {
    
    // Check if Facebook is available
    if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
      
      // Create the post
      let post = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
      
      post.completionHandler = {
        _ in
        self.floatingMenuView.fadeInButtonLayer()
      }
      
      floatingMenuView.fadeOutButtonLayer()
      
      let seconds: Double = 0.5
      let delay = seconds * Double(NSEC_PER_SEC)
      let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
      
      dispatch_after(dispatchTime, dispatch_get_main_queue(), {
        let image = self.scrollingView.getScreenShot()
        post.addImage(image)
        self.presentViewController(post, animated: true, completion: nil)
      })
      
    } else {
      
      // Facebook is not available. Show a warning.
      let alert = UIAlertController(title: "Facebook Unavailable", message: "User is not signed in", preferredStyle: .Alert)
      alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
      presentViewController(alert, animated: true, completion: nil)
    }
  }
  
  /**
   Show Twitter compost view.
   */
  func showTwitter() {
    
    // Check if Twitter is available
    if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
      
      // Create the tweet
      let tweet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
      tweet.setInitialText("Use this app to get up to date food recalls: \(App.name)")
      tweet.addURL(NSURL(string: "https://itunes.apple.com/app/id\(App.id)"))
      //      tweet.addImage(UIImage(named: Image.shareApp))
      
      presentViewController(tweet, animated: true, completion: nil)
      
    } else {
      
      // Twitter not available. Show a warning.
      let alert = UIAlertController(title: "Twitter Unavailable", message: "User is not signed in", preferredStyle: .Alert)
      alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
      presentViewController(alert, animated: true, completion: nil)
    }
  }
  
  /**
   Open link to app on App Store for rating and review.
   */
  func showAppStore() {
    
    let alert = UIAlertController(title: "Rate App", message: nil, preferredStyle: .Alert)
    
    alert.addAction(UIAlertAction(title: "Rate", style: .Default){
      _ in
      // Open App in AppStore
      let link = "https://itunes.apple.com/app/id\(App.id)"
      
      UIApplication.sharedApplication().openURL(NSURL(string: link)!)
      })
    
    alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
    
    presentViewController(alert, animated: true, completion: nil)
    
  }
}

extension ViewController: FloatingMenuViewDelegate {
  
  func creditsButtonPressed(state: Bool) {
    if state {
      print("showCredits")
      scrollingView.showCredits()
    } else {
      print("hideCredits")
      scrollingView.hideCredits()
    }
  }
  
  var adsButtonsEnabled: Bool {
    return true
  }
  
  var soundButtonSelected: Bool {
    get {
      return soundEnabled
    }
    
    set {
      self.soundEnabled = soundButtonSelected
    }
  }
  
  func facebookButtonPressed() {
    print("showFacebook")
    showFacebook()
  }
  
  func twitterButtonPressed() {
    print("showTwitter")
    showTwitter()
  }
  
  func removeAdsButtonPressed() {
    print("removeAds")
  }
  
  func restorePurchaseButtonPressed() {
    print("restorePurchases")
  }
  
  func rateButtonPressed() {
    print("rateApps")
    showAppStore()
  }
  
  func settingsButtonPressed() {
    print("showSettings")
    
    let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
    if let settingsVC = mainStoryboard.instantiateViewControllerWithIdentifier("SettingsViewController") as? SettingsViewController {
      
      stopSpeech()
      
      settingsVC.delegate = self
      
      let seconds = 0.5
      let delay = seconds * Double(NSEC_PER_SEC)
      let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
      
      dispatch_after(dispatchTime, dispatch_get_main_queue(), {
        self.navigationController?.pushViewController(settingsVC, animated: true)
        
      })
    }
  }
}

// MARK: - <#SettingsViewControllerDelegate#>
extension ViewController: SettingsViewControllerDelegate {
  func didSaveSettings() {
    rate = defaults.floatForKey(UserDefaultsKey.rate)
    pitch = defaults.floatForKey(UserDefaultsKey.pitch)
    volume = defaults.floatForKey(UserDefaultsKey.volume)
    
    preferredVoiceLanguageCode = defaults.valueForKey(UserDefaultsKey.languageCode) as? String
    preferredVoiceLanguageCodeIndex = defaults.integerForKey(UserDefaultsKey.languageCodeIndex)
  }
}































